import "camera.lua"

SCREEN_WIDTH, SCREEN_HEIGHT = 128, 64

local objects = {}

function Run()
  for _, o in pairs(objects) do
	o:move()
    o:draw()
    -- TODO: check collisions
  end
end

function Alloc(o)
  table.insert(objects, o)
end

function Free(o)
  local index
  for i, oi in pairs(objects) do
	if o == oi then
      index = i
      goto continue
    end
  end
  ::continue::
  if index then
    table.remove(objects, index)
  end
end

Object = {}

function Object:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.x = 0
  o.y = 0
  o.z = 0
  o.vx = 0
  o.vy = 0
  o.vz = 0
  o.theta = 0
  o.lines = {}
  o.explode = false
  o.state = 0
  Alloc(o)
  return o
end

function Object:move()
  self.x += self.vx
  self.y += self.vy
  self.z += self.vz
end

function Object:draw()
  if #self.lines == 0 or self.z <= CameraZ() then return end
  local zz = (self.z - CameraZ()) * 2
  local ratio = 128 / (zz + 128)
  local cx = (CameraX() - self.x) * ratio + SCREEN_WIDTH / 2
  local cy = (CameraY() - self.y) * ratio + SCREEN_HEIGHT / 2
  if self.explode then
    ExplodeVectorGraphic(self.lines, cx, cy, self.theta, 1 / ratio, self.state)
  else
    DrawVectorGraphic(self.lines, cx, cy, self.theta, 1 / ratio)
  end
end
