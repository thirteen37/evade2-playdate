import "camera.lua"
import "game.lua"
import "object.lua"
import "sound.lua"

local projectiles = {}

EProjectile = Object:new()

function EProjectile:fire(enemy)
  Alloc(self)
  table.insert(projectiles, self)
  local frames = 90 / GameDifficulty()
  self.state = 256
  PlaySound("enemy_shoot")
  self.x = enemy.x - 8
  self.y = enemy.y - 8
  self.z = enemy.z
  self.vx = (CameraX() - self.x) / frames
  self.vy = (CameraY() - self.y) / frames
  self.vz = CameraVZ() - (self.z - CameraZ()) / frames
end

function EProjectile:run()
  if CameraCollidesWith(self) then
    Hit(10)
    Free(self)
    Remove(projectiles, self)
  elseif self.x < CameraZ() then
    self.state -= 1
    if self.state <= 0 then
      Free(self)
      Remove(projectiles, self)
    end
  end
end

function EProjectileGenocide()
  for _, projectile in pairs(projectiles) do
    Free(projectile)
  end
  projectiles = {}
end

EBullet = EProjectile:new()

function EBullet:fire(enemy)
  self.lines = {
    {0 - 4, 0 - 4, 7 - 4, 0 - 4},
    {7 - 4, 0 - 4, 7 - 4, 7 - 4},
    {7 - 4, 7 - 4, 0 - 4, 7 - 4},
    {0 - 4, 7 - 4, 0 - 4, 0 - 4},
  }
  return EProjectile.fire(self, enemy)
end

function EBullet:run()
  EProjectile.run(self)
  self.theta += 40
end

EBomb = EProjectile:new()

function EBomb:fire(enemy)
  self.lines = {
    {1 - 8,  1 - 8,  5 - 8,  5 - 8},
    {5 - 8,  4 - 8, 12 - 8,  4 - 8},
    {11 - 8,  5 - 8, 16 - 8,  0 - 8},
    {4 - 8,  5 - 8,  4 - 8, 12 - 8},
    {12 - 8,  5 - 8, 12 - 8, 12 - 8},
    {5 - 8, 12 - 8, 12 - 8, 12 - 8},
    {5 - 8, 11 - 8,  0 - 8, 16 - 8},
    {11 - 8, 11 - 8, 16 - 8, 16 - 8},
    {8 - 8,  8 - 8,  9 - 8,  9 - 8},
  }
  return EProjectile.fire(self, enemy)
end

function EBomb:run()
  EProjectile.run(self)
  self.theta += self.x
end
