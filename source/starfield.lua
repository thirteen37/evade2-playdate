import "camera.lua"

local gfx <const> = playdate.graphics

local starX = {}
local starY = {}
local starZ = {}

NUM_STARS = 30

local function initStar(i)
  starX[i] = math.random(-256, 256) + CameraX()
  starY[i] = math.random(-256, 256) + CameraY()
  starZ[i] = CameraZ() + math.random(200, 512)
end

function StarfieldInit()
  for i = 1, NUM_STARS do
	initStar(i)
  end
end

function StarfieldRender()
  local cx = CameraX()
  local cy = CameraY()
  local cz = CameraZ()

  for i = 1, NUM_STARS do
    local zz = (starZ[i] - cz) * Z_SCALE
    if (zz < 0) then
      initStar(i)
      zz = (starZ[i] - cz) * Z_SCALE
    end
    local ratioX = SCREEN_WIDTH / (zz + SCREEN_WIDTH)
    local ratioY = SCREEN_HEIGHT / (zz + SCREEN_HEIGHT)
    local x = (SCREEN_WIDTH / 2) - (starX[i] - cx) * ratioX
    local y = (SCREEN_HEIGHT / 2) - (starY[i] - cy) * ratioY
    if x < 0 or x > SCREEN_WIDTH or y < 0 or y > SCREEN_HEIGHT then
      initStar(i)
    else
      local zDist = starZ[i] - cz
      if zDist < 128 then
        gfx.fillRect(x-1, y-1, 3, 3)
      elseif zDist < 256 then
        gfx.fillRect(x, y, 2, 2)
      else
        gfx.drawPixel(x, y)
      end
    end
  end
end
