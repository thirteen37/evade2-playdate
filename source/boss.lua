import "camera.lua"
import "game.lua"
import "object.lua"

Z_DIST = 256

local total_kills = 0

Boss = Object:new()

function Boss:init(type)
  Alloc(self)
  self.showsRadar = true
  self.collidable = true
  self.z = CameraZ() + Z_DIST
  self.state = 0
  self.vz = CameraVZ()
  self.type = type
  -- self.hit_points = 1  -- <<- debug
  self.hit_points = 20 + (GameDifficulty() * type)
  self.timer = 0
  self.dead = false
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

function Boss:exploding()
  self.state += 1
  if self.state > 58 then
    self.dead = true
    total_kills += 1
    Free(self)
    CameraVZ(CAMERA_VZ)
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
  self.lines_orig = self.lines
  self.w = 128
  self.h = 54
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
      EProjectileGenocide()
      self.explode = true
      self.run = self.exploding
      PlaySound("enemy_hit")
      return
    end
    self.lines = {}  -- hide
    self.state = self.state == 1 and 0 or 1
  else
    self.lines = self.lines_orig  -- show
    self:engage_player_random_xy()
  end
end

function Boss1:engage_player_random_xy()
  local difficulty = GameDifficulty()
  self.z = CameraZ() + Z_DIST - 10
  if self.state == 1 then
    self.theta += 5 + difficulty
  else
    self.theta -= 5 + difficulty
  end
  self.timer -= 1
  if self.timer > 0 then return end
  local eBomb = EBomb:new()
  eBomb:fire(self)
  self.timer = GameWave() > 20 and 10 or (50 - difficulty)
  if self.x - CameraX() < -300 then
    self.vx = math.random(3, 10 + difficulty)
  elseif self.x - CameraX() > 300 then
    self.vx = math.random(-10 - difficulty, -3)
  else
    self.vx = math.random(-10 - difficulty, 10 + difficulty)
  end
  if self.y - CameraY() < -300 then
    self.vy = math.random(3, 10 + difficulty)
  elseif self.x - CameraY() > 300 then
    self.vy = math.random(-10 - difficulty, -3)
  else
    self.vy = math.random(-10 - difficulty, 10 + difficulty)
  end
end

function Boss2:init()
  Boss.init(self, 2)
  self:init_orbit(math.random(0, 1))
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
  self.lines_orig = self.lines
  self.w = 128
  self.h = 73
  self.orbit_left = false
  PlayScore("sounds/evade2_02_stage2-boss.mid")
  self.timer = GameWave() > 20 and 20 or (50 - GameDifficulty())
  self.run = Boss2.start_action
end

function Boss2:init_orbit(left)
  local angle = left and 0 or (2 * math.pi)
  self.x = math.cos(angle) * 256
  self.z = CameraZ() + math.sin(angle) * 256
  self.y = CameraY() + math.random(30, 90)
  self.vy = math.random(-6 - GameDifficulty(), 6 + GameDifficulty())
  self.vx = 0
  self.vz = -50 - GameDifficulty() * 2
  self.state = left and 0 or 180
end

function Boss2:start_action()
  self.timer -= 1
  if self.timer > 0 then
    PlayerActive(true)
    self.run = Boss2.action
  end
end

function Boss2:action()
  if self:hit() then
    if self.hit_points <= 2 then
      self.state = 0
      self.vz = CameraVZ() - 3
      EProjectileGenocide()
      self.explode = true
      self.run = self.exploding
      PlaySound("enemy_hit")
      return
    end
    self.lines = {}  -- hide
  else
    self.lines = self.lines_orig  -- show
    self:engage_player_orbit()
  end
end

function Boss2:engage_player_orbit()
  local difficulty = GameDifficulty()
  if self.orbit_left then
    self.state -= difficulty
    if self.state < 0 then
      self.y = CameraY() + math.random(-150, 150)
      self.state = 0
      self.orbit_left = false
    else
      self.theta -= 12
    end
  else
    self.state += difficulty
    if self.state > 180 then
      self.y = CameraY() + math.random(-150, 150)
      self.state = 180
      self.orbit_left = true
    else
      self.theta += 12
    end
  end
  local rad = math.rad(self.state)
  self.x = math.cos(rad) * 512
  self.z = CameraZ() + math.sin(rad) * 512
  self.timer -= 1
  if self.timer <= 0 then
    self.timer = GameWave() > 20 and 20 or (50 - difficulty)
    local bomb = EBomb:new()
    bomb:fire(self)
  end
end

function Boss3:init()
  Boss.init(self, 3)
  self.x = CameraX() - 512
  self.y = CameraY()
  self.vx = 10
  self.vy = math.random(-3, 3)
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
  self.lines_orig = self.lines
  self.w = 128
  self.h = 74
  self.orbit_left = false
  PlayScore("sounds/evade2_06_stage_3_boss.mid")
  self.run = Boss3.start_action
end

function Boss3:start_action()
  self.y = CameraY()
  self.z = CameraZ() + Z_DIST
  if self.x > CameraX() then
    self.run = Boss3.action
  end
end

function Boss3:action()
  if self:hit() then
    if self.hit_points <= 2 then
      self.state = 0
      self.vz = CameraVZ() - 3
      EProjectileGenocide()
      self.explode = true
      self.run = self.exploding
      PlaySound("enemy_hit")
      return
    end
    self.lines = {}  -- hide
  else
    self.lines = self.lines_orig  -- show
    self:engage_player_flee()
  end
end

function Boss3:engage_player_flee()
  if self.orbit_left then
    self.state -= GameDifficulty()
    if self.state < 0 then
      self.state = 0
      self:randomize_flee()
      self.orbit_left = false
    end
  else
    self.state += GameDifficulty()
    if self.state > 90 then
      self.state = 90
      self:randomize_flee()
      self.orbit_left = true
    end
  end
  self.timer -= 1
  if self.timer > 0 then return end
  local bomb = EBomb:new()
  bomb:fire(self)
  self.timer = GameWave() > 20 and 20 or (50 - GameDifficulty())
  self.vx += math.random(-7, 7)
  self.vy += math.random(-7, 7)
end

function Boss3:randomize_flee()
  self.y = CameraY() + math.random(-150, 150)
  self.vy = math.random(-7, 7)
  self.vx = math.random(-7, 7)
  self.z = CameraZ() - 50
  self.vz = CameraVZ() + math.random(1, 7) * GameDifficulty()
  self.theta = math.random(-180, 180)
end

local boss

function BossWait()
  ObjectsMoveDraw()
  if PlayerDead() then
    BulletGenocide()
    EProjectileGenocide()
    Free(boss)
    return MODE_GAMEOVER
  end
  if boss.dead then
    BulletGenocide()
    EProjectileGenocide()
    Free(boss)
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

function BossKills(k)
  if k then total_kills = k end
  return total_kills
end
