import "camera.lua"
import "game.lua"
import "object.lua"

Boss = Object:new()

Z_DIST = 256

function Boss:init(type)
  self.z = CameraZ() + Z_DIST
  self.state = 0
  self.vz = CameraVZ()
  self.type = type
  self.hit_points = 20 + (GameDifficulty() * type)
  if type == 3 then
    self.x = CameraX() - 512
    self.vx = 10
    self.vy = math.random(-3, 3)
    self.lines = {
      { -21, -27, 21, 16 },
      { -21, 16, 21, -27 },
      { 21, -16, 11, -5 },
      { 11, -5, 21, 5 },
      { -21, 5, -11, -5 },
      { -11, -5, -21, -16 },
      { -11, 27, -32, 5 },
      { -32, 5, -21, -5 },
      { 11, 27, 32, 5 },
      { 32, 5, 21, -5 },
      { -21, -16, -64, -16 },
      { 21, -16, 64, -16 },
      { -11, 5, 0, 16 },
      { 0, 16, 11, 5 }
    }
    self.w = 128
    self.h = 54
    PlayScore("sounds/evade2_06_stage_3_boss.mid")
  elseif type == 2 then
    self:initOrbit(math.random(0, 1))
    self.lines = {
      { -55, -37, -9, 9 },
      { -64, 9, -37, -18 },
      { -37, 0, 0, -37 },
      { 0, -37, 37, 0 },
      { -55, 37, -9, -9 },
      { 55, -37, 9, 9 },
      { 64, 9, 37, -18 },
      { 55, 37, 9, -9 },
    }
    self.w = 128
    self.h = 73
    PlayScore("sounds/evade2_02_stage2-boss.mid")
  else
    self.x = CameraX() + 512
    self.vx = -10
    self.y = CameraY()
    self.lines = {
      { -18, -27, -64, 18 },
      { -64, 18, -46, 37 },
      { -46, 37, -27, 18 },
      { 18, -27, 64, 18 },
      { 64, 18, 46, 37 },
      { 46, 37, 27, 18 },
      { -55, 18, 0, -37 },
      { 0, -37, 55, 18 },
      { -27, 9, 0, 37 },
      { 0, 37, 27, 9 },
    }
    self.w = 128
    self.h = 74
    PlayScore("sounds/evade2_02_stage1_boss.mid")
  end
end

function BossWait()
  if boss.explode and boss.state > 58 then
    return MODE_NEXT_WAVE
  end
end

function BossEntry()
  CameraVZ(-20)
  boss = Boss:new()
  local wave = GameWave()
  if wave % 3 == 0 then
    boss:init(3)
  elseif wave % 2 == 0 then
    boss:init(2)
  else
    boss:init(1)
  end
end
