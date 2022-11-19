import "camera.lua"

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

local objects = {}

function ObjectsMoveDraw()
  for _, o in pairs(objects) do
    o:move()
    o:draw()
    if o.collidable and o.w == 0 and o.h == 0 then
      -- o is bullet?
      for _, oo in pairs(objects) do
        if o ~= oo and oo.collidable and oo.w > 0 and oo.h > 0 then
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
    return true
  end
  return false
end

function Free(o)
  return Remove(objects, o)
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
  o.showsRadar = false
  o.collidable = false
  return o
end

function Object:move()
  self.x += self.vx
  self.y += self.vy
  self.z += self.vz
end

local blip = geo.polygon.new(1, 0, 0, 0.5, 0, -0.5, 1, 0)
local function drawBlip(angle, distance)
  local transform = geo.affineTransform.new()
  transform:scale(math.min(distance / 50, 10), math.max(6000 / distance, 6))
  transform:translate(90, 0)
  transform:rotate(math.deg(angle))
  transform:translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
  gfx.fillPolygon(transform:transformedPolygon(blip))
end

function Object:draw()
  if #self.lines == 0 or self.z <= CameraZ() then return end
  local zz = (self.z - CameraZ()) * Z_SCALE
  local ratio = 128 / (zz + 128)
  local cx = (CameraX() - self.x) * ratio + SCREEN_WIDTH / 2
  local cy = (CameraY() - self.y) * ratio + SCREEN_HEIGHT / 2
  if self.explode then
    ExplodeVectorGraphic(self.lines, cx, cy, self.theta, 1 / ratio, self.state)
  else
    if not DrawVectorGraphic(self.lines, cx, cy, self.theta, 1 / ratio) and self.showsRadar then
      local dx = CameraX() - self.x
      local dy = CameraY() - self.y
      local angle = math.atan(dy, dx)
      local distance = (dx^2 + dy^2)^0.5
      drawBlip(angle, distance)
    end
  end
end

function ObjectRun()
  if not PlayerActive() then return end
  for _, o in pairs(objects) do
    if o.run then o:run() end
  end
end
