import "enemy.lua"
import "eprojectile.lua"
import "font.lua"
import "object.lua"
import "player.lua"

local enemies = {}
local asteriods = {}
local difficulty
local kills
local wave

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

function GameNext()
  Run()
  -- if kills > 0 then  -- <<- Debug
  if kills > ((10 + wave) * difficulty) then
    BulletGenocide()
    return MODE_NEXT_WAVE
  end
end

function GameEntry()
  wave += 1
  if wave % 4 == 0 then
    difficulty += 1
  end
  kills = 0
  CameraVZ(CAMERA_VZ)
  EnemyGenocide()
  PlayScore(getStageSong())
  gameBirth()
end

function GameKilled()
  kills += 1
end

function GameDifficulty()
  return difficulty
end

function GameInit()
  difficulty = 1
  kills = 0
  wave = 0
  PlayerInit()
end
