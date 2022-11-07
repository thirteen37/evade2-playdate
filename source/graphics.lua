local gfx <const> = playdate.graphics

function DrawVectorGraphic(graphic, x, y, theta, scaleFactor)
  return ExplodeVectorGraphic(graphic, x, y, theta, scaleFactor, nil)
end

function ExplodeVectorGraphic(graphic, x, y, theta, scaleFactor, step)
  local rad = math.rad(theta)
  local sint = math.sin(rad)
  local cost = math.cos(rad)

  for _, l in pairs(graphic) do
    local segx0, segy0, segx1, segy1 = table.unpack(l)
    local x0, y0, x1, y1 = segx0, segy0, segx1, segy1
    if scaleFactor then
      x0 /= scaleFactor
      y0 /= scaleFactor
      x1 /= scaleFactor
      y1 /= scaleFactor
    end
    if step then
      x0 += (segx0 / 8) * step
      y0 += (segy0 / 8) * step
      x1 += (segx1 / 8) * step
      y1 += (segy1 / 8) * step
    end
    gfx.drawLine(
      x0 * cost - y0 * sint + x,
      y0 * cost + x0 * sint + y,
      x1 * cost - y1 * sint + x,
      y1 * cost + x1 * sint + y)
  end
end
