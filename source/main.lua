import "CoreLibs/animation"
import "CoreLibs/timer"

import "attract.lua"
import "boss.lua"
import "camera.lua"
import "credits.lua"
import "game.lua"
import "game_over.lua"
import "get_ready.lua"
import "menu.lua"
import "next_wave.lua"
import "player.lua"
import "splash.lua"
import "starfield.lua"
import "warp.lua"

local gfx <const> = playdate.graphics

playdate.display.setInverted(true)

MODE_SPLASH    = 1
MODE_ATTRACT   = 2
MODE_CREDITS   = 3
MODE_GET_READY = 4
MODE_GAME      = 5
MODE_WARP      = 6
MODE_BOSS      = 7
MODE_NEXT_WAVE = 8
MODE_GAMEOVER  = 9
local game_mode = MODE_SPLASH
SplashEntry()
StarfieldInit()

function playdate.update()
  gfx.clear()
  CameraMove()
  BeforeRender()
  StarfieldRender()
  local prev_game_mode = game_mode
  local new_game_mode
  if game_mode == MODE_SPLASH then
    new_game_mode = SplashWait()
  elseif game_mode == MODE_ATTRACT then
    new_game_mode = AttractTypewriter()
  elseif game_mode == MODE_CREDITS then
    new_game_mode = CreditsTypewriter()
  elseif game_mode == MODE_GET_READY then
    new_game_mode = GetReadyRun()
  elseif game_mode == MODE_GAME then
    new_game_mode = GameNext()
  elseif game_mode == MODE_WARP then
    new_game_mode = WarpNext()
  elseif game_mode == MODE_BOSS then
    new_game_mode = BossWait()
  elseif game_mode == MODE_NEXT_WAVE then
    new_game_mode = NextWaveRun()
  elseif game_mode == MODE_GAMEOVER then
    new_game_mode = GameOverLoop()
  end
  ObjectRun()
  AfterRender()
  game_mode = new_game_mode or game_mode
  if prev_game_mode ~= game_mode then
    if game_mode == MODE_SPLASH then
      SplashEntry()
    elseif game_mode == MODE_ATTRACT then
      AttractEntry()
    elseif game_mode == MODE_CREDITS then
      CreditsEntry()
    elseif game_mode == MODE_GET_READY then
      GetReadyEntry()
    elseif game_mode == MODE_GAME then
      GameEntry()
    elseif game_mode == MODE_WARP then
      WarpEntry()
    elseif game_mode == MODE_BOSS then
      BossEntry()
    elseif game_mode == MODE_NEXT_WAVE then
      NextWaveEntry()
    elseif game_mode == MODE_GAMEOVER then
      GameOverEntry()
    end
  end
  gfx.animation.blinker.updateAll()
  playdate.timer.updateTimers()
end
