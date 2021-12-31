------------------------------------------------------------------------------------------
-- References
  -- LUA: https://learnxinyminutes.com/docs/lua/
  -- Hammerspoon: https://www.hammerspoon.org/docs/index.html
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Customize Config File (this file is added to .gitignore, local only)
-- All configurations must start with "CONFIG_NOSYNC_" in this file
if hs.fs.displayName("./config_nosync.lua") then
  require("config_nosync")
end

HYPER = {"cmd", "ctrl", "alt", "shift"}

-- Hammerspoon Arguments Configuration
  -- Disable useless window hints (icons at the front of every app with CMD+TAB)
  hs.hints.showTitleThresh = 0
  -- Duration of the alert shown when a hotkey created with a message. Default is 1 (second), set to 0 to disable
  hs.hotkey.alertDuration = 1
  -- The default duration for animations, in seconds. Default is 0.2, set to 0 to disable.
  hs.window.animationDuration = 0

-- Disable special characters (e.g. ALT+Q -> œ, ALT+SHIFT+Q -> Œ)
-- Note: This will also disable any hotkeys in any application
for key in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
  -- hs.hotkey.bind({"alt", "shift"}, key, function() end)
  hs.hotkey.bind({"alt"}, key, function() end)
end
print("Special characters keybindings Alt(Option)+KEY disabled...")
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Local Functions

  -- Automatically reload config upon any .lua file has changed (triggered by saving)
  local function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.console.clearConsole()
        hs.reload()
    end
  end
  hswatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
  hs.alert.show("Hammerspoon Config Loaded")

  -- Simulate Key Pressed:
  local function simulateKeyPressed(key)
    hs.eventtap.event.newKeyEvent(key, true):post()
    hs.eventtap.event.newKeyEvent(key, false):post()
  end

  -- Simulate ModsKey Pressed:
    -- mods[1] down -> mods[2] down .. -> key down -> key up -> .. -> mods[2] up -> mods[1] up
  -- mods: nil, or table (e.g. {"ctrl", "alt"})
  local function simulateModsKeyPressed(mods, key)
    for i = 1, #mods do
      hs.eventtap.event.newKeyEvent(mods[i], true):post()
    end
    hs.eventtap.event.newKeyEvent(key, true):post()
    hs.eventtap.event.newKeyEvent(key, false):post()
    for i = #mods, 1, -1 do
      hs.eventtap.event.newKeyEvent(mods[i], false):post()
    end
  end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Weather Menubar
weatherStatusBar = require("WeatherStatusBar")
if CONFIG_NOSYNC_WEATHER_CITY then
  weatherStatusBar:setCity(CONFIG_NOSYNC_WEATHER_CITY)
end
weatherStatusBar:setIdSecret("69548741", "pipaue2b")
weatherStatusBar:setHourWeatherEnabled(true)
weatherStatusBar:updateWeather()
periodicallyUpdateWeather = hs.timer.new(3600, function()
  weatherStatusBar:updateWeather()
end)
periodicallyUpdateWeather:start()

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Quick Search
-- quickSearch = require("QuickSearch")
-- quickSearch:setMods({"alt", "shift"})
-- quickSearch:setConfigs({
--   {key = '', searchUrl = "", fallbackUrl = "", message = ""},
--   {key = 'T', searchUrl = "https://translate.google.com/?sl=auto&tl=zh-CN&text=", fallbackUrl = "https://translate.google.com/?sl=auto&tl=zh-CN", message = "Google Translate"},
--   {key = 'S', searchUrl = "https://www.google.com/search?q=", fallbackUrl = "https://www.google.com/", message = "Search with Google"},
--   {key = 'G', searchUrl = "https://github.com/search?&q=", fallbackUrl = "https://github.com/", message = "Search with GitHub"},
--   {key = 'A', searchUrl = "https://cs.android.com/search?q=", fallbackUrl = "https://cs.android.com/", message = "Android Code Search"},
--   {key = 'B', searchUrl = "https://search.bilibili.com/all?keyword=", fallbackUrl = "https://www.bilibili.com/", message = "Search with Bilibili"},
--   {key = 'B', searchUrl = "http://www.baidu.com/s?wd=", fallbackUrl = "http://www.baidu.com/", message = "Search with Baidu"},
--   {key = 'C', searchUrl = "https://so.csdn.net/so/search/s.do?q=", fallbackUrl = "https://www.csdn.net/", message = "Search with CSDN"},
--   {key = 'W', searchUrl = "https://wikipedia.org/wiki/Special:Search/", fallbackUrl = "https://www.wikipedia.org/", message = "Search with Wikipedia"},
--   {key = 'Z', searchUrl = "https://www.zhihu.com/search?q=", fallbackUrl = "https://www.zhihu.com/", message = "Search with Zhihu"},
-- })

hyperSearch = require("QuickSearch")
hyperSearch:setMods(HYPER)
hyperSearch:setConfigs({
  -- {key = '', searchUrl = "", fallbackUrl = "", message = ""},
  {key = 'G', searchUrl = "https://www.google.com/search?q=", fallbackUrl = "https://www.google.com/", message = "Search with Google"},
  {key = 'T', searchUrl = "https://translate.google.com/?sl=auto&tl=zh-CN&text=", fallbackUrl = "https://translate.google.com/?sl=auto&tl=zh-CN", message = "Google Translate"},
  {key = 'B', searchUrl = "http://www.baidu.com/s?wd=", fallbackUrl = "http://www.baidu.com/", message = "Search with Baidu"},
})

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- App Launch
appLaunch = require("AppLaunch")
appLaunch:setMods({"alt"})
appLaunch:setConfigs({
  -- How to check id and name:
  -- 1. Application -> Right Click on app -> Show Package Contents
  -- 2. Open "Contents/Info.plist"
    -- id -> CFBundleIdentifier
    -- name -> CFBundleName
  -- {key = '', name = ""[, id = ""][,message = ""]},

  {key = 'Q', name = "IINA", id = "com.colliderli.iina"},
  {key = 'W', name = "WeChat", id = "com.tencent.xinWeChat"},  -- fixed
  {key = 'E', name = "NeteaseMusic", id = "com.netease.163music"},  -- fixed
  {key = 'R', name = "TickTick", id = "com.TickTick.task.mac"},
  {key = 'T', name = "Terminal", id = "com.apple.Terminal"},  -- system fixed
  {key = 'U', name = "App Cleaner", id = "com.nektony.App-Cleaner-SII"},
  {key = 'P', name = "Parallels Desktop", id = "com.parallels.desktop.console"},  -- fixed
  {key = 'A', name = "Launchpad", id = "com.apple.launchpad.launcher"},  -- system fixed
  {key = 'S', name = "System Preferences", id = "com.apple.systempreferences"},  -- system fixed
  {key = 'F', name = "ForkLift", id = "com.binarynights.ForkLift-3"},  -- fixed
  -- {key = 'F', name = "Finder", id = "com.apple.finder"},  -- fixed
  {key = 'H', name = "HazeOver", id = "com.pointum.hazeover"},  -- fixed
  -- {key = 'Z', name = "", id = ""},
  -- {key = 'X', name = "", id = ""},
  {key = 'C', name = "Chrome", id = "com.google.Chrome"},  -- fixed
  {key = 'V', name = "Code", id = "com.microsoft.VSCode", message = "VS Code"},  -- fixed
  {key = 'B', name = "Bartender 3", id = "com.surteesstudios.Bartender"},
  {key = 'N', name = "Notion", id = "notion.id"},  -- fixed
  {key = 'M', name = "Microsoft Remote Desktop", id = "com.microsoft.rdc.macos"},
})

-- Other alt keys bind
hs.hotkey.bind("alt", 'D', function() simulateKeyPressed('F11') end)
hs.hotkey.bind("alt", 'Z', function() simulateModsKeyPressed({"ctrl"}, "left") end)
hs.hotkey.bind("alt", 'X', function() simulateModsKeyPressed({"ctrl"}, "right") end)
