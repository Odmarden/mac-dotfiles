-- Define the slots as Unit Rectangles: {x, y, width, height} 
-- 0.0 is the start, 0.5 is the middle, 1.0 is the end.
local slots = {
    {x=0,   y=0,   w=0.5, h=0.5}, -- Top Left
    {x=0.5, y=0,   w=0.5, h=0.5}, -- Top Right
    {x=0,   y=0.5, w=0.5, h=0.5}, -- Bottom Left
    {x=0.5, y=0.5, w=0.5, h=0.5}  -- Bottom Right
}

local ghosttyFilter = hs.window.filter.new('Ghostty')

ghosttyFilter:subscribe(hs.window.filter.windowCreated, function(win)
    -- Get all open Ghostty windows on the CURRENT screen
    local screen = win:screen()
    local windows = hs.window.filter.new('Ghostty'):getWindows()
    
    -- Filter to only count windows on the active screen to keep math clean
    local screenWindows = {}
    for _, w in ipairs(windows) do
        if w:screen() == screen then
            table.insert(screenWindows, w)
        end
    end

    local slotIndex = (#screenWindows - 1) % #slots + 1
    local rect = slots[slotIndex]
    
    -- Using moveUnit is more reliable than 'move' for grid layouts
    -- It treats the screen as a 1x1 coordinate system
    win:moveToUnit(rect)
end)