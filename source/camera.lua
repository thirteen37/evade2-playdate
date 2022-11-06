local x = 0
local y = 0
local z = 0
local vx = 0
local vy = 0
local vz = 0
CAMERA_VZ = 6

function CameraMove()
  x += vx
  y += vy
  z += vz
end

function CameraX()
  return x
end

function CameraY()
  return y
end

function CameraZ()
  return z
end

function CameraVZ(new_vz)
  vz = new_vz
end
