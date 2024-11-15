local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local system_info = sbar.add("item", {
  icon = {
    drawing = false
  },
  label = {
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 10.0,
    },
    max_width = 1000,
  },
  position = "right",
  update_freq = 5,
})

local function exec(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return (result:gsub("^%s*(.-)%s*$", "%1")) -- Trim whitespace
end

local function get_cpu_usage()
  return tonumber(exec("top -l 1 -n 0 -s 0 | grep 'CPU usage' | awk '{print $3}' | cut -d'%' -f1")) or 0
end

local function get_memory_usage()
  local active_memory = tonumber(exec("vm_stat | grep 'Pages active' | awk '{print $3}' | sed 's/\\.//'")) or 0
  local total_memory = tonumber(exec("sysctl hw.memsize | awk '{print $2}'")) or 1
  return math.floor((active_memory * 4096 / total_memory) * 100)
end

local function get_battery_info()
  local percentage = tonumber(exec("pmset -g batt | grep -Eo '\\d+%' | cut -d% -f1")) or 0
  local is_charging = exec("pmset -g batt | grep 'AC Power'") ~= ""
  return percentage, is_charging
end

local function get_disk_usage()
  return exec("df -h / | awk 'NR==2 {print $5}' | sed 's/%//'")
end

local function get_network_speed()
  local rx_bytes = tonumber(exec("netstat -ib | grep -e 'en0' -m 1 | awk '{print $7}'")) or 0
  local tx_bytes = tonumber(exec("netstat -ib | grep -e 'en0' -m 1 | awk '{print $10}'")) or 0
  sbar.sleep(1)
  local rx_bytes_new = tonumber(exec("netstat -ib | grep -e 'en0' -m 1 | awk '{print $7}'")) or 0
  local tx_bytes_new = tonumber(exec("netstat -ib | grep -e 'en0' -m 1 | awk '{print $10}'")) or 0
  
  local rx_speed = (rx_bytes_new - rx_bytes) / 1024 -- KB/s
  local tx_speed = (tx_bytes_new - tx_bytes) / 1024 -- KB/s
  
  return string.format("%.1f↓ %.1f↑", rx_speed, tx_speed)
end

local function get_temperature()
  return exec("osx-cpu-temp | cut -d'.' -f1")
end

local function get_fan_speed()
  return exec("fan speed | awk '{print $3}'")
end

local function get_public_ip()
  return exec("curl -s https://api.ipify.org")
end

local function get_volume()
  return exec("osascript -e 'output volume of (get volume settings)'")
end

local function get_brightness()
  return exec("brightness -l | grep -oE '[0-9]*\\.[0-9]*' | tail -n 1")
end

local function get_uptime()
  return exec("uptime | awk '{print $3}' | sed 's/,//'")
end

local function update()
  local date = os.date("%a %d %b")
  local time = os.date("%H:%M:%S")
  local cpu = get_cpu_usage()
  local mem = get_memory_usage()
  local batt, charging = get_battery_info()
  local disk = get_disk_usage()
  local net = get_network_speed()
  local temp = get_temperature()
  local fan = get_fan_speed()
  local volume = get_volume()
  local brightness = get_brightness()
  local uptime = get_uptime()
  
  local battery_icon = charging and "🔌" or "🔋"
  
  local info = string.format("%s %d%% | CPU: %.1f%% | MEM: %d%% | DISK: %s%% | NET: %s KB/s | " ..
                             "TEMP: %s°C | FAN: %s RPM | VOL: %s%% | BRIGHT: %s%% | " ..
                             "UP: %s | %s %s",
    battery_icon, batt, cpu, mem, disk, net, temp, fan, volume, brightness, uptime, date, time)
  
  system_info:set({
    label = {
      string = info
    }
  })
end

system_info:subscribe("routine", update)
system_info:subscribe("forced", update)

-- Uncomment to include public IP (updates less frequently to avoid API abuse)
-- system_info:subscribe({ events = {"routine"}, timer = 3600 }, function()
--   local public_ip = get_public_ip()
--   system_info:set({
--     label = {
--       string = system_info.label.string .. " | IP: " .. public_ip
--     }
--   })
-- end)

-- Force initial update
update()
