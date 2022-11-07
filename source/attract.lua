import "CoreLibs/animator"
import "CoreLibs/timer"

import "enemy.lua"
import "graphics.lua"

local gfx <const> = playdate.graphics

local screen
local currentScreen
local typewriter
local hold

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

local function next(t)
  if t and t ~= hold then return end
  screen += 1
  if screen > #SCREENS then
    return MODE_SPLASH
  end
  currentScreen = SCREENS[screen]
  local charCount = #(currentScreen.text)
  typewriter = gfx.animator.new(100 * (charCount+1), 1, charCount)
  hold = playdate.timer.new(2000, next)
end

function AttractTypewriter()
  if playdate.buttonJustPressed(playdate.kButtonA) then
    return MODE_GAME
  end
  if playdate.buttonJustPressed(playdate.kButtonRight) then
    return next()
  end
  DrawVectorGraphic(currentScreen.graphics, 64, 24, 0, 2)
  FontPrintString(currentScreen.x, currentScreen.y, currentScreen.text:sub(1, math.floor(typewriter:currentValue())), 1)
  if screen > #SCREENS then
    return MODE_SPLASH
  end
end

function AttractEntry()
  screen = 0
  next()
end
