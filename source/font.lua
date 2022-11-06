import "CoreLibs/object"

import "charset.lua"

local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

WIDTH = 9

function FontWrite(x, y, c, fscale)
  if Charset[c] then
    for _, l in pairs(Charset[c]) do
      local x0, y0, x1, y1 = table.unpack(l)
      gfx.drawLine(x0 + x, y0 + y, x1 + x, y1 + y)
    end
    return WIDTH * fscale
  else
    return 6 * fscale
  end
end

function FontPrintString(x, y, s, fscale)
  local xx = x
  for c in s:gmatch(".") do
    xx += FontWrite(xx, y, c, fscale)
  end
  return xx - x -- width of string printed
end

function FontPrintStringRotatedX(x, y, theta, s, fscale)
  local cost = math.cos(math.rad(theta))
  local sint = math.sin(math.rad(theta))
  local transform = geo.affineTransform.new()
  transform:scale(fscale)
  transform:scale(1, sint)
  transform:translate(0, cost)
  local xx = x
  for c in s:gmatch(".") do
    if Charset[c] then
      local offset = geo.affineTransform.new()
      offset:translate(xx, y)
      for _, l in pairs(Charset[c]) do
        local ls = geo.lineSegment.new(table.unpack(l))
        gfx.drawLine((transform * offset):transformedLineSegment(ls))
      end
      xx += WIDTH * fscale
    else
      xx += 6 * fscale
    end
  end
  return xx - x
end
