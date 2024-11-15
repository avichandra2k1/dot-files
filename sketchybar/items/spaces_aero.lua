local colors = require("colors")

local LIST_ACTIVE = "aerospace list-workspaces --occupied"
local LIST_CURRENT = "aerospace list-workspaces --focused"

local function debug_print(message)
    print("[DEBUG] " .. message)
    sbar.exec("echo '" .. os.date('%Y-%m-%d %H:%M:%S') .. " [DEBUG] " .. message .. "' >> /tmp/sketchybar_debug.log")
end

local workspace_item = sbar.add("item", "workspace_indicator", {
    position = "left",
    drawing = true,
    label = { 
        string = "Workspaces: Initializing...",
        color = colors.grey
    },
    background = { 
        color = colors.bg1,
        border_color = colors.lightblack 
    }
})

local function executeCommand(command, callback)
    debug_print("Executing command: " .. command)
    sbar.exec(command, function(output)
        if output == "" then
            debug_print("Command returned empty output")
            callback("ERROR: Empty output")
        else
            debug_print("Command output: " .. output)
            callback(output)
        end
    end)
end

local function updateWorkspaces()
    debug_print("Updating workspaces")
    executeCommand(LIST_ACTIVE, function(activeWorkspacesOutput)
        if activeWorkspacesOutput:match("^ERROR") then
            workspace_item:set({
                label = { 
                    string = "Error getting active workspaces",
                    color = colors.red
                }
            })
            return
        end
        
        executeCommand(LIST_CURRENT, function(currentWorkspaceOutput)
            if currentWorkspaceOutput:match("^ERROR") then
                workspace_item:set({
                    label = { 
                        string = "Error getting current workspace",
                        color = colors.red
                    }
                })
                return
            end
            
            local currentWorkspace = currentWorkspaceOutput:match("[^\r\n]+")
            debug_print("Current workspace: " .. tostring(currentWorkspace))
            
            local workspaceString = "Workspaces: "
            local activeWorkspacesFound = false
            for workspace in activeWorkspacesOutput:gmatch("[^\r\n]+") do
                activeWorkspacesFound = true
                if workspace == currentWorkspace then
                    workspaceString = workspaceString .. "[" .. workspace .. "] "
                else
                    workspaceString = workspaceString .. workspace .. " "
                end
            end
            
            if not activeWorkspacesFound then
                workspaceString = workspaceString .. "No active workspaces found"
            end
            
            workspace_item:set({
                label = { 
                    string = workspaceString,
                    color = colors.grey
                }
            })
        end)
    end)
end

-- Create custom event for workspace changes
sbar.add("event", "workspace_changed", {
    update_freq = 0,
    script = "sketchybar --trigger update_workspaces"
})

-- Subscribe to the custom event and built-in events
sbar.subscribe({"workspace_changed", "space_change", "windows_on_spaces_change"}, function(env)
    debug_print("Workspace change event triggered")
    updateWorkspaces()
end)

-- Initial update
updateWorkspaces()

debug_print("Workspace indicator script loaded and initialized")
