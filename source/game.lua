import "CoreLibs/animator"

import "font.lua"

local gfx <const> = playdate.graphics

local nextFunction

local function getStageSong()
  if wave % 5 == 0 then
    return "evade2_09_stage_5.mid"
  elseif wave % 4 == 0 then
    return "evade2_08_stage4_new.mid"
  elseif wave % 3 == 0 then
    return "evade2_05_stage_3.mid"
  elseif wave % 2 == 0 then
    return "evade2_03_stage2.mid"
  else
    return "evade2_01_stage1.mid"
  end
end

local function startGame()
  difficulty = 1
  kills = 0
  wave = 1
  PlayScore(getStageSong())
end

local function getReady()
  FontPrintStringRotatedX(30, 35, theta:currentValue(), "GET READY!")
  if theta:ended() then
    startGame()
    nextFunction = startGame
  end
end

function GameNext()
  return nextFunction()
end

function GameEntry()
  nextFunction = getReady
  theta = gfx.animator.new(2166, 90, 870)
  PlayScore("sounds/evade2_12_next_wave.mid")
end
