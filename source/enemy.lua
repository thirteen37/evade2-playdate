import "CoreLibs/timer"

import "enemy_gfx.lua"
import "game.lua"
import "object.lua"

local function initScout(self)
  self.x = CameraX() + math.random(-256, 256)
  self.y = CameraY() + math.random(-256, 256)
  self.z = CameraZ() + 1024
  self.vz = CAMERA_VZ - 12
  self.vy = 0
  self.vx = 0
  self.theta = math.random(-50, 50)
end

local function initBomber(self)
  self.x = CameraX() + math.random(1, 128)
  self.y = CameraY() + math.random(1, 128)
  self.z = CameraZ() - 30
  self.vz = CAMERA_VZ + 1 + GameWave()
  self.vx = 0
  self.vy = 0
end

local function initAssault(self)
  local angle = math.random(0, 1) * 2 * math.pi
  self.x = math.cos(angle) * 256
  self.z = CameraZ() + math.sin(angle) * 256
  self.y = CameraY()
  self.vx = 0
  self.vy = 0
  self.vz = 0
  self.state = 0
end

Enemy = Object:new()

local function init(self)
  self.explode = false
  self.collision = false
  local wave = GameWave()
  local type = math.random(1, (wave > 3) and 3 or wave)
  if type == 1 then
    self.lines = ENEMY_GRAPHICS["scout"]
    initScout(self)
  elseif type == 2 then
    self.lines = ENEMY_GRAPHICS["heavy_bomber"]
    initBomber(self)
  elseif type == 3 then
    self.lines = ENEMY_GRAPHICS["assault"]
    initAssault(self)
  end
end

local function respawn(self)
  local delay = math.random(60, 90) / 30 * 1000
  self.respawnDelay = playdate.timer.performAfterDelay(delay, init, self)
end

function Enemy:entry()
  return respawn(self)
end
