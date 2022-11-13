import "CoreLibs/timer"

import "camera.lua"
import "game.lua"
import "player.lua"

local gfx <const> = playdate.graphics

local continue = false

function NextWaveEntry()
  playdate.timer.performAfterDelay(4000, function() continue = true end)
  PlayScore("sounds/evade2_12_next_wave.mid")
  CameraVX(0)
  CameraVY(0)
  CameraVZ(30)
end

function NextWaveRun()
  FontPrintString(35, 5, "WARP TO ACE!", 190/256)
  RechargeShield()
  RechargePower()
  if continue then
    return MODE_GAME
  end
end
