import "CoreLibs/timer"

import "enemy_gfx.lua"
import "eprojectile.lua"
import "game.lua"
import "object.lua"

DELTA_THETA = 8

local function fireTime()
  return (60 / GameDifficulty() + math.random(1, 60 / GameDifficulty()))
end

local function initScout(self)
  self.x = CameraX() + math.random(-256, 256)
  self.y = CameraY() + math.random(-256, 256)
  self.z = CameraZ() + 1024
  self.vz = CAMERA_VZ - 12
  self.vy = 0
  self.vx = 0
  self.w = 128
  self.h = 38
  self.theta = math.random(-50, 50)
end

local function initBomber(self)
  self.x = CameraX() + math.random(1, 128)
  self.y = CameraY() + math.random(1, 128)
  self.z = CameraZ() - 30
  self.vz = CAMERA_VZ + 1 + GameWave()
  self.w = 128
  self.h = 55
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
  self.w = 128
  self.h = 46
  self.state = 0
end

local function behindCamera(self)
  return self.z <= CameraZ()
end

local function death(self)
  if self.collision then
    GameKilled()
    self.explode = true
    self.state = 0
    return true
  else
    return false
  end
end

local function bank(self, delta)
  delta = delta or 45
  if self.bank_left then
    self.theta -= DELTA_THETA
    if self.theta < -delta then
      self.bank_left = false
    end
  else
    self.theta += DELTA_THETA
    if self.theta > delta then
      self.bank_left = true
    end
  end
end

local function fire(self)
  self.fireCountdown -= 1
  if self.fireCountdown <= 0 then
    if CameraVX() ~= 0 or CameraVY() ~= 0 then
      self.fireCountdown += 1
      return
    end
    local isBullet = (math.random(0, 5) > 0)
    if isBullet then
      local bullet = EBullet:new()
      bullet:fire(self)
    else
      local bomb = EBomb:new()
      bomb:fire(self)
    end
    self.fireCountdown = fireTime()
  else
    self.fireCountdown -= 1
  end
end

local respawn

EXPLODE_FRAMES = 58
local function explode(self)
  self.explode = true
  self.state += 1
  if behindCamera(self) or self.state > EXPLODE_FRAMES then
    respawn(self)
  end
  self.movement = explode
end

local function runAway(self)
  self.vz += self.state
  self.vx += self.vx > 0 and .1 or -.1
  self.vy += self.vy > 0 and .1 or -.1
  if behindCamera(self) or (self.z - CameraZ()) > 1024 then
    respawn(self)
    return
  end
  if death(self) then
    self.movement = explode
    return
  end
  bank(self)
  fire(self)
end

local function seek(self)
  if behindCamera(self) then
    respawn(self)
    return
  end
  if death(self) then
    explode(self)
    return
  end
  -- bank(self)
  fire(self)
  self.theta += 8
  if self.z - CameraZ() < math.random(256, 512) then
    self.state = -1
    self.movement = runAway
    return
  end
end

Enemy = Object:new()

local enemies = {}

function EnemyGenocide()
  for _, enemy in pairs(enemies) do
    Free(enemy)
  end
  enemies = {}
end

local function init(self)
  self.explode = false
  self.collision = false
  self.fireCountdown = fireTime()
  self.respawnDelay = nil
  local wave = GameWave()
  local type = math.random(1, (wave > 3) and 3 or wave)
  if type == 1 then
    self.lines = ENEMY_GRAPHICS["scout"]
    initScout(self)
    self.movement = seek
  elseif type == 2 then
    self.lines = ENEMY_GRAPHICS["heavy_bomber"]
    initBomber(self)
    self.movement = evade
  elseif type == 3 then
    self.lines = ENEMY_GRAPHICS["assault"]
    initAssault(self)
    self.movement = orbit
  end
end

function Enemy:move()
  local movement = self.movement
  if movement then movement(self) end
  Object.move(self)
end

function respawn(self)
  if self.respawnDelay then return end
  local delay = math.random(60, 90) / 30 * 1000
  self.respawnDelay = playdate.timer.performAfterDelay(delay, init, self)
end

function Enemy:entry()
  Alloc(self)
  table.insert(enemies, self)
  return respawn(self)
end

function Enemy:showsRadar()
  return true
end

function Enemy:collidable()
  return true
end
