import "bullet.lua"
import "camera.lua"

local gfx <const> = playdate.graphics

MAX_POWER = 100
MAX_LIFE = 100
DELTACONTROL = 11

local shield = -1
local power = -1
local player_alt = false
local player_hit = false
local active = false
local hud = false

function PlayerInit()
  CameraVZ(CAMERA_VZ)
  power = MAX_POWER
  shield = MAX_LIFE
  BulletGenocide()
  player_alt = false
  player_hit = false
end

function RechargeShield()
  if shield < MAX_LIFE then
    shield += 1
  end
end

function RechargePower()
  if power < MAX_POWER then
    power += 1
  end
end

local function drawMeter(side, value, deltaXMeter, deltaYMeter)
  local y = 45
  value //= 10
  if side == 0 then
    -- left
    for i = 1, 9 do
      if i >= value then
        gfx.drawPixel(1 + deltaXMeter, y + deltaYMeter)
        gfx.drawPixel(1 + deltaXMeter, y + 1 + deltaYMeter)
      else
        gfx.drawLine(1 + deltaXMeter, y + deltaYMeter, 3 + deltaXMeter, y + deltaYMeter)
        gfx.drawLine(1 + deltaXMeter, y + 1 + deltaYMeter, 4 + deltaXMeter, y + 1 + deltaYMeter)
      end
      y -= 3
    end
  else
    -- right
    for i = 1, 9 do
      if i >= value then
        gfx.drawPixel(126 + deltaXMeter, y + deltaYMeter)
        gfx.drawPixel(126 + deltaXMeter, y + 1 + deltaYMeter)
      else
        gfx.drawLine(124 + deltaXMeter, y + deltaYMeter, 126 + deltaXMeter, y + deltaYMeter)
        gfx.drawLine(123 + deltaXMeter, y + 1 + deltaYMeter, 126 + deltaXMeter, y + 1 + deltaYMeter)
      end
      y -= 3
    end
  end
end

function BeforeRender()
  if not active then return end
  if playdate.buttonJustPressed(playdate.kButtonA) then
    local deltaX = 0
    local deltaY = 0
    if playdate.buttonIsPressed(playdate.kButtonRight) then
      deltaX = -12
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
      deltaX = 12
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
      deltaY = -12
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
      deltaY = 12
    end
    local bullet = Bullet:new()
    bullet:fire(deltaX, deltaY, player_alt)
    player_alt = not player_alt
  end
  if playdate.buttonIsPressed(playdate.kButtonB) then
    if power > 0 then
      CameraVZ(CameraVZ() * 2)
      power -= 1
    else
      CameraVZ(CAMERA_VZ)
    end
  else
    CameraVZ(CAMERA_VZ)
    power += 1
    if power > MAX_POWER then
      power = MAX_POWER
    end
  end
  if playdate.buttonIsPressed(playdate.kButtonRight) then
    CameraVX(-DELTACONTROL)
  elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
    CameraVX(DELTACONTROL)
  else
    CameraVX(0)
  end
  if playdate.buttonIsPressed(playdate.kButtonDown) then
    CameraVY(DELTACONTROL)
  elseif playdate.buttonIsPressed(playdate.kButtonUp) then
    CameraVY(-DELTACONTROL)
  else
    CameraVY(0)
  end
end

local hud_console = gfx.image.new("images/hud_console_img")
-- local hud_bottom_left = gfx.image.new("images/hud_bottom_left")
-- local hud_bottom_right = gfx.image.new("images/hud_bottom_right")
-- local hud_top_left = gfx.image.new("images/hud_top_left")
-- local hud_top_right = gfx.image.new("images/hud_top_right")
local hud_crosshairs = gfx.image.new("images/hud_crosshairs")
function AfterRender()
  if not hud then return end
  if player_hit then
    playdate.display.setInverted(false)
  else
    playdate.display.setInverted(true)
  end
  player_hit = false
  local consoleX = 40
  local consoleY = 58
  deltaXMeter = 0
  deltaYMeter = 0
  deltaXCrossHairs = 0
  deltaYCrossHairs = 0
  if playdate.buttonIsPressed(playdate.kButtonRight) then
    consoleX = 38
    deltaXMeter = -1
    deltaXCrossHairs = 4
  elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
    consoleX = 42
    deltaXMeter = 1
    deltaXCrossHairs = -4
  end
  if playdate.buttonIsPressed(playdate.kButtonUp) then
    consoleY = 56
    deltaYMeter = -1
    deltaYCrossHairs = 4
  elseif playdate.buttonIsPressed(playdate.kButtonDown) then
    consoleY = 60
    deltaYMeter = 1
    deltaYCrossHairs = -4
  end
  hud_console:draw(consoleX, consoleY)
  hud_crosshairs:draw(53 + deltaXCrossHairs, 30 + deltaYCrossHairs)
  drawMeter(0, shield, deltaXMeter, deltaYMeter)
  drawMeter(1, power, deltaXMeter, deltaYMeter)
end

function Hit(amount)
  shield -= amount
  if shield > 0 then
    player_hit = true
    PlaySound("player_hit")
  end
end

function PlayerDead()
  return shield <= 0
end

function PlayerActive(a)
  if a ~= nil then
    active = a
  end
  return active
end

function PlayerHud(h)
  if h ~= nil then
    hud = h
  end
  return hud
end
