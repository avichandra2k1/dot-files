local colors = require("colors")
local settings = require("settings")

local LIST_ALL = "aerospace list-workspaces --all"
local LIST_CURRENT = "aerospace list-workspaces --focused"
local spaces = {}
local current_workspace = nil

local function updateWorkspaceItem(workspaceName, isSelected)
    local spaceId = "workspace_" .. workspaceName
    if not spaces[spaceId] then
        spaces[spaceId] = sbar.add("item", spaceId, {
            position = "left",
            padding_left = 5,
            padding_right = 5,
            icon = {
                string = workspaceName,
                font = {
                    style = settings.font.style_map["Bold"],
                    size = 14.0,
                },
                color = colors.grey,
                highlight_color = colors.yellow,
            },
            click_script = "aerospace workspace " .. workspaceName .. " && sketchybar --trigger workspace_changed " .. workspaceName,
        })
    end
    if spaces[spaceId].isSelected ~= isSelected then
        spaces[spaceId]:set({
            icon = { highlight = isSelected },
        })
        spaces[spaceId].isSelected = isSelected
    end
end

local function updateSpaces(newCurrentWorkspace)
    if newCurrentWorkspace and newCurrentWorkspace ~= current_workspace then
        if current_workspace then
            updateWorkspaceItem(current_workspace, false)
        end
        updateWorkspaceItem(newCurrentWorkspace, true)
        current_workspace = newCurrentWorkspace
    end
end

local function initialDraw()
    sbar.exec(LIST_ALL, function(workspacesOutput)
        for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
            updateWorkspaceItem(workspaceName, false)
        end
        sbar.exec(LIST_CURRENT, function(focusedWorkspaceOutput)
            updateSpaces(focusedWorkspaceOutput:match("[^\r\n]+"))
        end)
    end)
end

-- Create an observer to trigger updates
local space_observer = sbar.add("item", {
    position = "left",
    drawing = false,
    updates = true,
})

-- Subscribe to relevant events
space_observer:subscribe({"aerospace_workspace_change", "front_app_switched"}, function()
    sbar.exec(LIST_CURRENT, function(focusedWorkspaceOutput)
        updateSpaces(focusedWorkspaceOutput:match("[^\r\n]+"))
    end)
end)

-- Subscribe to custom event for immediate update on click
space_observer:subscribe("workspace_changed", function(env)
    updateSpaces(env.SELECTED_WORKSPACE)
end)

-- Initial draw
initialDraw()

print("workspace_indicator.lua loaded and initialized")
