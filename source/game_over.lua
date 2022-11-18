import "CoreLibs/animator"

import "bullet.lua"
import "enemy.lua"
import "object.lua"

local gfx <const> = playdate.graphics

local theta
local wave

function GameOverLoop()
  if theta:ended() then
    return MODE_SPLASH
  end
  FontPrintStringRotatedX(96, 90, theta:currentValue(), "GAME OVER", 3)
  FontPrintString(wave < 10 and 62 or 53, 140, "WAVES SURVIVED: " .. (wave - 1), 2)
end

function GameOverEntry()
  PlayerActive(false)
  PlayerHud(false)
  EProjectileGenocide()
  BulletGenocide()
  EnemyGenocide()
  theta = gfx.animator.new(3333, 0, 1200)
  wave = GameWave()
  PlayScore("sounds/evade2_10_game_over.mid")
end
