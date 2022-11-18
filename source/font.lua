import "CoreLibs/object"

import "charset.lua"

local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics

CHAR_WIDTH = 9

local function fontWrite(x, y, c, fscale)
  if Charset[c] then
    for _, l in pairs(Charset[c]) do
      local x0, y0, x1, y1 = table.unpack(l)
      gfx.drawLine(x0 * fscale + x,
                   y0 * fscale + y,
                   x1 * fscale + x,
                   y1 * fscale + y)
    end
    return CHAR_WIDTH * fscale
  else
    return 6 * fscale
  end
end

function FontPrintString(x, y, s, fscale)
  fscale = fscale or 1
  gfx.setLineWidth(math.floor(fscale / 2))
  local xx = x
  for c in s:gmatch(".") do
    xx += fontWrite(xx, y, c, fscale)
  end
  return xx - x -- width of string printed
end

function FontPrintStringRotatedX(x, y, theta, s, fscale)
  fscale = fscale or 1
  gfx.setLineWidth(math.floor(fscale / 2))
  local rad = math.rad(theta)
  local cost = math.cos(rad)
  local sint = math.sin(rad)
  local transform = geo.affineTransform.new()
  transform:scale(fscale)
  transform:scale(1, sint)
  transform:translate(0, cost)
  local xx = x
  for c in s:gmatch(".") do
    if Charset[c] then
      for _, l in pairs(Charset[c]) do
        local ls = geo.lineSegment.new(table.unpack(l))
        gfx.drawLine(transform:translatedBy(xx, y):transformedLineSegment(ls))
      end
      xx += CHAR_WIDTH * fscale
    else
      xx += 6 * fscale
    end
  end
  return xx - x
end
