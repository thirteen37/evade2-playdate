import "CoreLibs/timer"

import "camera.lua"
import "game.lua"
import "player.lua"

local gfx <const> = playdate.graphics

local continue

function NextWaveEntry()
  PlayerActive(false)
  continue = false
  playdate.timer.performAfterDelay(2167, function() continue = true end)
  PlayScore("sounds/evade2_12_next_wave.mid")
  CameraVZ(CAMERA_VZ)
end

function NextWaveRun()
  FontPrintString(26, 5, "NEXT WAVE " .. (GameWave() + 1), 200/256)
  RechargeShield()
  RechargePower()
  if continue then
    return MODE_GAME
  end
end
