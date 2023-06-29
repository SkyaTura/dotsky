hs.logger.defaultLogLevel = "info"

hyper                     = { "cmd", "alt", "ctrl" }
shift_hyper               = { "cmd", "alt", "ctrl", "shift" }
ctrl_cmd                  = { "cmd", "ctrl" }

col                       = hs.drawing.color.x11

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.zzspoons = {
  url = "https://github.com/zzamboni/zzSpoons",
  desc = "zzamboni's spoon repository",
}

spoon.SpoonInstall.use_syncinstall = true

Install = spoon.SpoonInstall

-- Returns the bundle ID of an application, given its path.
function appID(app)
  if hs.application.infoForBundlePath(app) then
    return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
  end
end

myGrid = { w = 6, h = 4 }
Install:andUse("WindowGrid",
  {
    config = {
      gridGeometries =
      { { myGrid.w .. "x" .. myGrid.h } }
    },
    hotkeys = { show_grid = { hyper, "g" } },
    start = true
  }
)

Install:andUse("Hammer",
  {
    repo = 'zzspoons',
    config = { auto_reload_config = false },
    hotkeys = {
      config_reload = { hyper, "r" },
      toggle_console = { hyper, "y" }
    },
    start = true
  }
)

Install:andUse("Caffeine", {
  start = false,
})

Install:andUse("TurboBoost",
  {
    disable = true,
    config = {
      disable_on_start = true
    },
    hotkeys = {
      toggle = { hyper, "0" }
    },
    start = true,
    --                   loglevel = 'debug'
  }
)

Install:andUse("KSheet", {
  hotkeys = {
    toggle = { hyper, "/" }
  }
})

local localfile = hs.configdir .. "/local/init-local.lua"
if hs.fs.attributes(localfile) then
  dofile(localfile)
end

aw = hs.application.watcher
br = hs.brightness
aw_stored = {}
aw_last = nil
aw_current_app = nil

aw_brightness_watcher = aw.new(function(app, event)
  local stored = aw_stored[app]
  if (event == aw.deactivated and aw_last) then
    print('leave', app, event, stored, aw_last)
    aw_stored[app] = aw_last
    aw_last = nil
  end
  if (event ~= aw.activated) then return end
  print('enter', app, event, stored, aw_last)
  aw_current_app = app

  if (not aw_last) then
    aw_last = br.get()
  end

  if (not stored) then return end

  br.set(stored)
end)
aw_brightness_watcher:start()

function reloadAWBrightness()
  -- this functions isn't really used, however, it is needed
  -- because Lua will garbage collect the watcher if no further reference exist
  aw_brightness_watcher:stop()
  aw_brightness_watcher:start()
end

local wf = hs.window.filter

wf_arc = wf.new('Arc'):setSortOrder(wf.sortByCreated)
wf_kitty = wf.new('kitty'):setSortOrder(wf.sortByCreated)

function sleep(s)
  local ntime = os.clock() + s / 10
  repeat until os.clock() > ntime
end

function showWindow(filter, index)
  if (filter == nil) then return end
  local window = filter:getWindows()[index]
  if (window == nil) then return end


  if (filter == wf_arc and aw_stored['Arc'] and aw_stored['Arc'] < 75 and aw_current_app ~= 'Arc') then
    print('override')
    aw_last = br.get()
    br.set(aw_stored['Arc'])
    sleep(0.5)
  end
  window:focus()
end

hs.hotkey.bind({ "cmd", "ctrl" }, "1", function() showWindow(wf_kitty, 1) end)
hs.hotkey.bind({ "cmd", "ctrl" }, "2", function() showWindow(wf_arc, 1) end)
hs.hotkey.bind({ "cmd", "ctrl" }, "3", function() showWindow(wf_arc, 2) end)
hs.hotkey.bind({ "cmd", "ctrl" }, "4", function() showWindow(wf_arc, 3) end)
