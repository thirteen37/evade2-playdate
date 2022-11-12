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

function CameraX(new_x)
  if new_x then x = new_x end
  return x
end

function CameraY(new_y)
  if new_y then y = new_y end
  return y
end

function CameraZ(new_z)
  if new_z then z = new_z end
  return z
end

function CameraVZ(new_vz)
  if new_vz then vz = new_vz end
  return vz
end

function CameraVY(new_vy)
  if new_vy then vy = new_vy end
  return vy
end

function CameraVX(new_vx)
  if new_vx then vx = new_vx end
  return vx
end
