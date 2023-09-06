local mod1 = {'shift', 'cmd' }
local mod2 = { 'ctrl', 'cmd' }
local mod3 = { 'rightcmd', 'rightalt' }
local mod4 = { 'shift', 'ctrl', 'cmd' }

-- window switcher. Source : https://github.com/dmgerman/hs_select_window.spoon
hs.loadSpoon("hs_select_window")

local SWbindings = {
   all_windows =  { {'alt'}, 'space'},
   app_windows =  { {'alt', 'shift'}, 'space'}
}   
spoon.hs_select_window:bindHotkeys(SWbindings)

local function getWindowInfo()
   local window = hs.window.focusedWindow()
   local windowFrame = window:frame()
   local screenFrame = window:screen():frame()
   return window, windowFrame, screenFrame
end

local function moveWindow(X, Y, W, H)
   local window, windowFrame, screenFrame = getWindowInfo()
   windowFrame.x = screenFrame.x + (screenFrame.w * X)
   windowFrame.y = screenFrame.y + (screenFrame.h * Y)
   windowFrame.w = screenFrame.w * W
   windowFrame.h = screenFrame.h * H
   window:setFrame(windowFrame)
end

local function centeredWindow()
   local window, windowFrame, screenFrame = getWindowInfo()
   windowFrame.w = screenFrame.w * 0.8
   windowFrame.h = screenFrame.h * 0.8
   windowFrame.x = screenFrame.x + (screenFrame.w - windowFrame.w) / 2
   windowFrame.y = screenFrame.y + (screenFrame.h - windowFrame.h) / 2
   window:setFrame(windowFrame)
end

local function newTerminal()
   local application = hs.application.get('Alacritty')
   if application then
      application:activate(false)
      hs.eventtap.keyStroke({ 'cmd' }, 'N')
   else
      hs.application.launchOrFocus('Alacritty')
   end
end

hs.fnutils.each({
   { key = 'D', app = 'Discord' },
   { key = 'T', app = 'Alacritty' },
   { key = 'C', app = 'Visual Studio Code' },
   { key = 'E', app = 'CotEditor' },
   { key = 'B', app = 'Firefox' }
}, function(map)
   hs.hotkey.bind(mod2, map.key, function() hs.application.launchOrFocus(map.app) end)
end)

-- mapping = {{modifier, key, function}}
local mappings = {
   -- Create new Finder window in active workspace
   {mod2, 'F', function() hs.application.find("Finder"):selectMenuItem({"Fichier", "Nouvelle fenêtre Finder"}) end},
   {mod3, 'F', function() hs.application.find("Finder"):selectMenuItem({"Fichier", "Nouvelle fenêtre Finder"}) end},
   -- Create new terminal window in active workspace
   {mod4, 'T', newTerminal},
   {mod1, 'return', newTerminal},
   -- Move window to the left
   {mod2, 'H', function() moveWindow(0, 0, 0.5, 1) end},
   {mod2, 'left', function() moveWindow(0, 0, 0.5, 1) end},
   -- Move window to the right
   {mod2, 'L', function() moveWindow(0.5, 0, 0.5, 1) end},
   {mod2, 'right', function() moveWindow(0.5, 0, 0.5, 1) end},
   -- Move window to upper right
   {mod2, 'I', function() moveWindow(0.5, 0, 0.5, 0.5) end},
   -- Move window to lower right
   {mod2, 'K', function() moveWindow(0.5, 0.5, 0.5, 0.5) end},
   -- Move window to upper left
   {mod2, 'U', function() moveWindow(0, 0, 0.5, 0.5) end},
   -- Move window to lower left
   {mod2, 'J', function() moveWindow(0, 0.5, 0.5, 0.5) end},
   -- Maximize window
   {mod2, 'P', function() hs.window.focusedWindow():maximize() end},
   {mod2, 'up', function() hs.window.focusedWindow():maximize() end},
   -- Almost maximized window
   {mod2, 'M', centeredWindow },
   {mod2, 'down', centeredWindow }
}

for i, mapping in ipairs(mappings) do
   hs.hotkey.bind(mapping[1], mapping[2], mapping[3])
end