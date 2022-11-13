import "camera.lua"
import "object.lua"

MAX_BULLETS = 6
BULLET_VZ = 15

local bullets = {}

Bullet = Object:new()

function Bullet:fire(deltaX, deltaY, alt)
  if #bullets >= MAX_BULLETS then
    Free(self)
    return
  end
  table.insert(bullets, self)
  PlaySound("player_shoot")
  self.z = CameraZ()
  if alt then
    self.x = CameraX() + 28
    self.y = CameraY() - 28
    self.state = 20
  else
    self.x = CameraX() - 28
    self.y = CameraY() - 28
    self.state = -20
  end
  self.vx = deltaX
  self.vy = deltaY
  self.vz = CameraVZ() + BULLET_VZ
  self.lines = {
      {-8, -8, 8, 8},
      {-8, 8, 8, -8},
  }
end

function Bullet:run()
  Object.run(self)
  if self.collision then
    self.collision = false
    self.explode = true
    self.state = 0
  elseif self.explode then
    self.state += 1
    if self.state > 20 then
      Free(self)
      Remove(bullets, self)
    end
  elseif self.z - CameraZ() > 512 then
    Free(self)
    Remove(bullets, self)
  else
    self.theta += self.state
  end
end

function BulletGenocide()
  for _, bullet in pairs(bullets) do
    Free(bullet)
  end
  bullets = {}
end

function Bullet:collidable()
  return true
end
