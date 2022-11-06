import "CoreLibs/animation"
import "CoreLibs/animator"

import "font.lua"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

local sequence = snd.sequence.new("sounds/evade2_00_intro.mid")
local blinker = gfx.animation.blinker.new()
blinker.onDuration = 500
blinker.offDuration = 500
local theta
local attractMode = true
local transition

function SplashEntry()
  sequence:play()
  blinker:startLoop()
  theta = gfx.animator.new(2400, 90, 810)
  transition = false
  playdate.timer.new(8000, function()
                       transition = true
                       end)
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
  else

  end
end

function SplashExit()
  blinker:stop()
end
