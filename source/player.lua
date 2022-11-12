import "camera.lua"

MAX_POWER = 100
MAX_LIFE = 100

shield = -1
power = -1
num_bullets = 0
player_alt = false
player_hit = false

function PlayerInit()
  CameraVZ(CAMERA_VZ)
  power = MAX_POWER
  shield = MAX_LIFE
  num_bullets = 0
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