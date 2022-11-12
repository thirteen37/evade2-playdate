import "CoreLibs/animator"

import "enemy.lua"
import "font.lua"
import "player.lua"

local gfx <const> = playdate.graphics

local nextFunction
local enemies = {}
local asteriods = {}
local difficulty
local kills
local wave
local theta

function GameWave()
  return wave
end

local function getStageSong()
  if wave % 5 == 0 then
    return "sounds/evade2_09_stage_5.mid"
  elseif wave % 4 == 0 then
    return "sounds/evade2_08_stage4_new.mid"
  elseif wave % 3 == 0 then
    return "sounds/evade2_05_stage_3.mid"
  elseif wave % 2 == 0 then
    return "sounds/evade2_03_stage2.mid"
  else
    return "sounds/evade2_01_stage1.mid"
  end
end

local function gameBirth()
  for i = 1, 3 do
    local enemy = Enemy:new()
    enemy:entry()
    table.insert(enemies, enemy)
  end
  if wave > 3 then
    local num_asteroids = math.min(math.max(wave, 3), 1) + 1
    for i = 1, num_asteroids do
      -- table.insert(asteroids, Asteroid:new())
    end
  end
 end

local function startGame()
  difficulty = 1
  kills = 0
  wave = 1
  PlayScore(getStageSong())
  PlayerInit()
  gameBirth()
end

local function gameRun()
  for _, enemy in pairs(enemies) do
    enemy:move()
    enemy:draw()
  end
  for _, asteroid in pairs(asteriods) do
    asteroid:draw()
  end
  if kills > ((10 + wave) * difficulty) then
    kills = 120
    CameraVZ(30)
    return MODE_NEXT_WAVE
  end
end

local function getReady()
  FontPrintStringRotatedX(30, 35, theta:currentValue(), "GET READY!")
  if theta:ended() then
    startGame()
    nextFunction = gameRun
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

function GameKilled()
  kills += 1
end

function GameDifficulty()
  return difficulty
end
