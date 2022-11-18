import "CoreLibs/timer"

import "enemy_gfx.lua"
import "graphics.lua"
import "sound.lua"

local screen
local currentScreen
local typewriterTimer
local holdTimer
local offset

local SCREENS = {
  {graphics=ENEMY_GRAPHICS["scout"],
   text="SCOUT",
   x=146, y=156},
  {graphics=ENEMY_GRAPHICS["heavy_bomber"],
   text="BOMBER",
   x=133, y=156},
  {graphics=ENEMY_GRAPHICS["assault"],
   text="ASSAULT",
   x=119, y=156},
}

local next
local function typewriterUpdate(t)
  if offset < #(currentScreen.text) then
    offset += 1
    PlaySound("next_attract_char")
  else
    t:remove()
    if not holdTimer then
      holdTimer = playdate.timer.new(2000, next)
    end
  end
end

function next()
  offset = 0
  if typewriterTimer then
    typewriterTimer:remove()
    typewriterTimer = nil
  end
  if holdTimer then
    holdTimer:remove()
    holdTimer = nil
  end
  screen += 1
  if screen > #SCREENS then
    return MODE_SPLASH
  end
  currentScreen = SCREENS[screen]
  typewriterTimer = playdate.timer.new(100, typewriterUpdate)
  typewriterTimer.repeats = true
  PlaySound("next_attract_screen")
  PlaySound("next_attract_char")
end

function AttractTypewriter()
  if playdate.buttonJustPressed(playdate.kButtonA) then
    return MODE_GET_READY
  end
  if playdate.buttonJustPressed(playdate.kButtonRight) then
    return next()
  end
  DrawVectorGraphic(currentScreen.graphics, 200, 83, 0, 1)
  FontPrintString(currentScreen.x, currentScreen.y, currentScreen.text:sub(1, offset), 3)
  if screen > #SCREENS then
    return MODE_SPLASH
  end
end

function AttractEntry()
  screen = 0
  next()
end
