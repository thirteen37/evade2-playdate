import "player.lua"
import "sound.lua"

local ds <const> = playdate.datastore
local menu = playdate.getSystemMenu()
local settings = {music=true, sfx=true, controls=false}

local function saveSettings()
  ds.write(settings, "settings")
end

local function musicCallback(b)
  settings.music = b
  MuteMusic(not settings.music)
end

local function sfxCallback(b)
  settings.sfx = b
  MuteSfx(not settings.sfx)
end

local function controlsCallback(b)
  settings.controls = b
  InvertControls(settings.controls)
end

local function restoreSettings()
  for k, v in pairs(ds.read("settings") or {}) do
    settings[k] = v
  end
  MuteMusic(not settings.music)
  MuteSfx(not settings.sfx)
  InvertControls(settings.controls)
end

restoreSettings()

menu:addCheckmarkMenuItem("Music", settings.music, musicCallback)
menu:addCheckmarkMenuItem("SFX", settings.sfx, sfxCallback)
menu:addCheckmarkMenuItem("Invert controls", settings.controls, controlsCallback)
