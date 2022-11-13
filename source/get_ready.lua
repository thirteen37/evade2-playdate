import "CoreLibs/animator"

import "game.lua"

local gfx <const> = playdate.graphics

local theta

function GetReadyEntry()
  theta = gfx.animator.new(2166, 90, 870)
  PlayScore("sounds/evade2_12_next_wave.mid")
  GameInit()
end

function GetReadyRun()
  FontPrintStringRotatedX(30, 35, theta:currentValue(), "GET READY!")
  if theta:ended() then
    return MODE_GAME
  end
end
