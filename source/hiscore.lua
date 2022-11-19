import "boss.lua"
import "game.lua"
import "graphics.lua"

local ds <const> = playdate.datastore
local gfx <const> = playdate.graphics
local data = {}

local function restoreScore()
  data = ds.read() or {}
  if data.enemy_kills then TotalKills(data.enemy_kills) end
  if data.boss_kills then BossKills(data.boss_kills) end
  if data.max_wave then MaxWave(data.max_wave) end
end

restoreScore()

local function updateScore()
  data = {
    enemy_kills=TotalKills(),
    boss_kills=BossKills(),
    max_wave=MaxWave(),
  }
  local img = gfx.image.new(SCREEN_WIDTH, SCREEN_HEIGHT, gfx.kColorWhite)
  gfx.pushContext(img)
  FontPrintString(25, 28, "EVADE 2", 3)
  FontPrintString(15, 62, "CURRENT/HIGHEST WAVE", 1)
  FontPrintString(20, 84, tostring(GameWave() or 0) .. "/" .. tostring(data.max_wave), 2)
  FontPrintString(15, 112, "ENEMIES KILLED", 1)
  FontPrintString(20, 134, tostring(data.enemy_kills), 2)
  FontPrintString(15, 162, "BOSSES KILLED", 1)
  FontPrintString(20, 184, tostring(data.boss_kills), 2)
  gfx.popContext()
  img:setInverted(true)
  playdate.setMenuImage(img)
end

local function saveScore()
  updateScore()
  ds.write(data)
end

function playdate.gameWillTerminate()
  saveScore()
end

function playdate.deviceWillSleep()
  saveScore()
end

function playdate.gameWillPause()
  updateScore()
end
