import "sound.lua"

local menu = playdate.getSystemMenu()

local function musicCallback(b)
  MuteMusic(not b)
end

local function sfxCallback(b)
  MuteSfx(not b)
end

menu:addCheckmarkMenuItem("Music", true, musicCallback)
menu:addCheckmarkMenuItem("SFX", true, sfxCallback)
