import "camera.lua"

SCREEN_WIDTH, SCREEN_HEIGHT = 128, 64

local objects = {}

function Run()
  for _, o in pairs(objects) do
    o:move()
    o:draw()
    if o:collidable() and o.w == 0 and o.h == 0 then
      -- o is bullet?
      for _, oo in pairs(objects) do
        if o ~= oo and oo:collidable() and oo.w > 0 and oo.h > 0 then
          -- oo is enemy
          if math.abs(o.z - oo.z) < BULLET_VZ and
            math.abs(o.x - oo.x) < oo.w and
            math.abs(o.y - oo.y) < oo.h then
            o.collision = true
            oo.collision = true
            break
          end
        end
      end
    end
  end
end

function Alloc(o)
  table.insert(objects, o)
end

function Remove(t, o)
  local index
  for i, oi in pairs(t) do
	if o == oi then
      index = i
      goto continue
    end
  end
  ::continue::
  if index then
    table.remove(t, index)
  end
end

function Free(o)
  Remove(objects, o)
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
  o.w = 0
  o.h = 0
  o.collision = false
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

function Object:showsRadar()
  return false
end

function Object:collidable()
  return false
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
    if not DrawVectorGraphic(self.lines, cx, cy, self.theta, 1 / ratio) and self:showsRadar() then
      local dx = CameraX() - self.x
      local dy = CameraY() - self.y
      local angle = math.atan(dy, dx)
      DrawVectorGraphic(
        {
          {1 - 2, 0 - 2, 2 - 2, 0 - 2},
          {0 - 2, 1 - 2, 3 - 2, 1 - 2},
          {0 - 2, 2 - 2, 3 - 2, 2 - 2},
          {1 - 2, 3 - 2, 2 - 2, 3 - 2},
        },
        SCREEN_WIDTH / 2 + math.cos(angle) * 32,
        SCREEN_HEIGHT / 2 + math.sin(angle) * 32,
        0, 1
      )
    end
  end
end

function Object:run()
end

function ObjectRun()
  for _, o in pairs(objects) do
    o:run()
  end
end

function Object:collidesWithCamera()
  return math.abs(self.z - CameraZ()) < math.abs(self.vz) and
    math.abs(self.x - CameraX()) < 64 and
    math.abs(self.y - CameraY()) < 64
end
