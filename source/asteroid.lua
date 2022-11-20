import "object.lua"

Asteroid = Object:new()

local alt = false
local asteroids = {}

function Asteroid:init_rock()
  if alt then
    self.x = CameraX() + math.random(0, 512)
    self.state = -4
  else
    self.x = CameraX() - math.random(0, 512)
    self.state = 4
  end
  alt = not alt
  self.y = CameraY() + math.random(-100, 100)
  self.z = CameraZ() + 768
  self.vz = CAMERA_VZ - 4
  self.lines = {
    {-8,-24,-16,-24},
    {-16,-24,-32,-8},
    {-32,-8,-32,0},
    {-32,0,-8,24},
    {-8,24,8,24},
    {8,24,24,8},
    {16,16,24,16},
    {24,16,40,0},
    {40,0,24,-16},
    {32,-8,32,-16},
    {32,-16,16,-32},
    {16,-32,0,-32},
    {0,-32,-16,-16}
  }
end

function Asteroid:clipped()
  if self.state > 0 then
    if self.x > CameraX() + 1024 then
      return true
    end
  else
    if self.x < CameraX() - 1024 then
      return true
    end
  end
  if self.z < CameraZ() or self.z > CameraZ() + 768 then
	return true
  end
  return false
end

function Asteroid:run()
  if #self.lines == 0 then return end
  if CameraCollidesWith(self) then
	if PlayerActive() then
      Hit(30)
    end
    self.vz = CameraVZ() + 2
    self.z = CameraZ() + 10
    self.vx = math.random(-8, 8)
  elseif self:clipped() then
    self:respawn()
    return
  end
  self.theta += 16
  self.vy = CameraVY() / 2
end

function Asteroid:respawn()
  self.lines = {}
  self.respawnDelay = playdate.timer.performAfterDelay(math.random(1, 3) * 1000, Asteroid.init_rock, self)
end

function Asteroid:entry()
  Alloc(self)
  table.insert(asteroids, self)
  self:respawn()
end

function AsteroidGenocide()
  for _, asteroid in pairs(asteroids) do
    Free(asteroid)
  end
  asteroids = {}
end
