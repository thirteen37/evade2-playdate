import "CoreLibs/animation"
import "CoreLibs/timer"

import "splash.lua"

local gfx <const> = playdate.graphics

playdate.display.setScale(2)
playdate.display.setInverted(true)

MODE_SPLASH    = 1
MODE_ATTRACT   = 2
MODE_CREDITS   = 3
MODE_GAME      = 4
MODE_NEXT_WAVE = 5
MODE_GAMEOVER  = 6
local game_mode = MODE_SPLASH
SplashEntry()

function playdate.update()
  gfx.clear()
  local prev_game_mode = game_mode
  local new_game_mode
  if game_mode == MODE_SPLASH then
    new_game_mode = SplashWait()
  elseif game_mode == MODE_ATTRACT then
  elseif game_mode == MODE_CREDITS then
  elseif game_mode == MODE_GAME then
  elseif game_mode == MODE_NEXT_WAVE then
  elseif game_mode == MODE_GAMEOVER then
  end
  game_mode = new_game_mode or game_mode
  if prev_game_mode ~= game_mode then
    if game_mode == MODE_SPLASH then
      SplashEntry()
    elseif game_mode == MODE_ATTRACT then
    elseif game_mode == MODE_CREDITS then
    elseif game_mode == MODE_GAME then
    elseif game_mode == MODE_NEXT_WAVE then
    elseif game_mode == MODE_GAMEOVER then
    end
  end
  gfx.animation.blinker.updateAll()
  playdate.timer.updateTimers()
end
