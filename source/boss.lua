import "camera.lua"
import "game.lua"
import "object.lua"

Z_DIST = 256

Boss = Object:new()

function Boss:init(type)
  Alloc(self)
  self.z = CameraZ() + Z_DIST
  self.state = 0
  self.vz = CameraVZ()
  self.type = type
  self.hit_points = 20 + (GameDifficulty() * type)
end

function Boss:hit()
  if self.collision then
    self.hit_points -= 1
    self.collision = false
    return true
  else
    return false
  end
end

Boss1 = Boss:new()
Boss2 = Boss:new()
Boss3 = Boss:new()

function Boss1:init()
  Boss.init(self, 1)
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
  self.run = Boss1.start_action
end

function Boss1:start_action()
  self.y = CameraY()
  self.z = CameraZ() + Z_DIST
  if self.x <= CameraX() then
    self.run = Boss1.action
  end
end

function Boss1:action()
  if self:hit() then
    if self.hit_points <= 2 then
      self.state = 0
      self.vz = CameraVZ() - 3
      self.run = self.explode
      return
    end
    self.lines = {}  -- hide
    self.state = self.state == 1 and 0 or 1
  else
    self.lines = {} -- show
    self:engage_player_random_xy()
  end
end

function Boss1:engage_player_random_xy()
  self.z = CameraZ() + Z_DIST - 10
  if self.state == 1 then
    self.theta += 5 + GameDifficulty()
  else
    self.theta -= 5 + GameDifficulty()
  end
  self.timer -= 1
  if self.timer > 0 then return end
  local eBullet = EBullet:new()
  eBullet:fire(self)
  self.timer = GameWave() > 20 and 10 or (40 - GameDifficulty())
  if self.x - CameraX() < -300 then
    self.vx = math.random(3, 10 + GameDifficulty())
  elseif self.x - CameraX() > 300 then
    self.vx = math.random(-3, -10 - GameDifficulty())
  else
    self.vx = math.random(-10 - GameDifficulty(), 10 + GameDifficulty())
  end
  if self.y - CameraY() < -300 then
    self.vy = math.random(3, 10 + GameDifficulty())
  elseif self.x - CameraY() > 300 then
    self.vy = math.random(-3, -10 - GameDifficulty())
  else
    self.vy = math.random(-10 - GameDifficulty(), 10 + GameDifficulty())
  end
end

function Boss2:init()
  Boss.init(self, 2)
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
  self.run = Boss2.start_action
end

function Boss2:start_action()
  self.timer += 1
  if self.timer > 0 then
    self.run = Boss2.action
  end
end

function Boss3:init()
  Boss.init(self, 3)
  self.x = CameraX() - 512
  self.y = CameraY()
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
  self.run = Boss3.start_action
end

function BossWait()
  if boss.explode and boss.state > 58 then
    return MODE_NEXT_WAVE
  end
end

function BossEntry()
  PlayerActive(true)
  CameraVZ(-20)
  local wave = GameWave()
  if wave % 3 == 0 then
    boss = Boss3:new()
  elseif wave % 2 == 0 then
    boss = Boss2:new()
  else
    boss = Boss1:new()
  end
  boss:init()
end
