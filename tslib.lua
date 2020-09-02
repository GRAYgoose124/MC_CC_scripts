-- Library helpers
function get_screen ()
    local sides = { "top", "bottom", "left", "right", "front", "back" }

    for i = 1, #sides do
        if peripheral.isPresent(sides[i]) then
            if peripheral.getType(sides[i]) == "monitor" then
                local w, h = peripheral.call(sides[i], "getSize")
                local win = window.create(peripheral.wrap(sides[i]), 1, 1, w, h)
                win.setBackgroundColor(colors.black)
                win.clear()
                return win
            end
        end
    end
end
--
-- Button helpers
function quit()
    return true, nil
end

function nothing()
    return false, nil
end

function in_button (x, y, buttons)
    for _, button in ipairs(buttons) do
        if button.x <= x and x <= (button.x + button.w - 1) and button.y <= y and y <= (button.y + button.h - 1) then
            return true, button
        end
    end
    return false, nil
end
--
-- Button class
Button = { x = 1, y = 1, w = 2, h = 2, func = nothing, text = '', toggle_color_off = "e", toggle_color_on = "5" }
Button.__index = Button

function Button:draw (win)
    win.setCursorPos(self.x, self.y)
    for i = self.y,self.y+self.h-1,1 do
        if i == self.y then
              win.blit(string.rep(' ', self.w - #self.text) .. self.text, string.rep("f", self.w), string.rep(self.color, self.w))
        else
              win.blit(string.rep(' ', self.w), string.rep(self.color, self.w), string.rep(self.color, self.w))
        end
        win.setCursorPos(self.x, i)
    end
end

function Button:new (x, y, w, h, func, text, toggle_color_off, toggle_color_on)
    local b = {}
    setmetatable(b, self)
    b.x = x
    b.y = y
    b.w = w
    b.h = h
    if toggle_color_off == nil or toggle_color_on == nil then
        toggle_color_off = self.toggle_color_off
        toggle_color_on = self.toggle_color_on
    end
    b.color = toggle_color_off
    b.toggle_color_off = toggle_color_off
    b.toggle_color_on = toggle_color_on
    b.func = func
    b.text = text
  
    return b
end
--
-- Event Loop
function event_loop (buttons)
    local done = false
    local click_timer = nil
    local win = get_screen()
    
    while not done do
        for _, button in ipairs(buttons) do 
            button:draw(win)
        end
        win.redraw()
        
        local event, side, x, y = os.pullEvent("monitor_touch")
        if event == "monitor_touch" then
            local inside, button = in_button(x, y, buttons)
            if inside then
                done, result = button.func()    
                if button.color == button.toggle_color_off then
                    button.color = button.toggle_color_on
                else
                    button.color = button.toggle_color_off
                end
            end
        end

  
    end
    win.clear()
end
--
-- todo autogridder/from 2d button table based on win size
-- todo threaded graphics blitting, prob new lib for that
-- todo, click visual thread and paraminput/result extraction with state variable buttons

-- test/example
-- local bs = {
    -- Button:new(1, 1, 5, 1, nothing, "click"),
    -- Button:new(1, 2, 4, 1, quit, "quit"),
    -- Button:new(1, 3, 6, 1, nothing, "toggle", "e", "b") 
-- }

-- event_loop(bs)
