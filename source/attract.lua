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
   x=46, y=52},
  {graphics=ENEMY_GRAPHICS["heavy_bomber"],
   text="BOMBER",
   x=41, y=52},
  {graphics=ENEMY_GRAPHICS["assault"],
   text="ASSAULT",
   x=37, y=52},
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
    return MODE_GAME
  end
  if playdate.buttonJustPressed(playdate.kButtonRight) then
    return next()
  end
  DrawVectorGraphic(currentScreen.graphics, 64, 24, 0, 2)
  FontPrintString(currentScreen.x, currentScreen.y, currentScreen.text:sub(1, offset))
  if screen > #SCREENS then
    return MODE_SPLASH
  end
end

function AttractEntry()
  screen = 0
  next()
end
