import "CoreLibs/animation"
import "CoreLibs/animator"

import "camera.lua"
import "font.lua"
import "sound.lua"

local gfx <const> = playdate.graphics

local blinker = gfx.animation.blinker.new()
blinker.onDuration = 500
blinker.offDuration = 500
local theta
local attractMode = true
local transition

function SplashEntry()
  PlayScore("sounds/evade2_00_intro_long.mid")
  blinker:startLoop()
  theta = gfx.animator.new(2400, 90, 810)
  transition = false
  playdate.timer.new(8000, function() transition = true end)
  CameraVZ(CAMERA_VZ)
end

function SplashWait()
  FontPrintStringRotatedX(15, 25, theta:currentValue(), "EVADE 2", 2)
  if blinker.on then
    FontPrintString(45, 52, "START", 1)
  end
  if transition or playdate.buttonJustPressed(playdate.kButtonRight) then
    local next_mode
    if attractMode then
      next_mode = MODE_ATTRACT
      attractMode = false
    else
      next_mode = MODE_CREDITS
      attractMode = true
    end
    return next_mode
  end
  if playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB) then
    return MODE_GET_READY
  end
end

function SplashExit()
  blinker:stop()
end
