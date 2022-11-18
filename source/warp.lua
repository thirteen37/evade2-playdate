import "CoreLibs/timer"

import "camera.lua"
import "game.lua"
import "player.lua"

local continue

function WarpEntry()
  PlayerActive(false)
  continue = false
  playdate.timer.performAfterDelay(4000, function() continue = true end)
  PlayScore("sounds/evade2_12_next_wave.mid")
  CameraVX(0)
  CameraVY(0)
  CameraVZ(30)
end

function WarpNext()
  FontPrintString(84, 45, "WARP TO ACE!", 2.5)
  RechargeShield()
  RechargePower()
  if continue then
    return MODE_BOSS
  end
end
