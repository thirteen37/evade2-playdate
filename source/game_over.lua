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
  FontPrintStringRotatedX(30, 20, theta:currentValue(), "GAME OVER", 1)
  FontPrintString(wave < 9 and 18 or 13, 45, "WAVES SURVIVED: " .. (wave - 1), 0.75)
end

function GameOverEntry()
  EProjectileGenocide()
  BulletGenocide()
  EnemyGenocide()
  theta = gfx.animator.new(3333, 0, 1200)
  wave = GameWave()
  PlayScore("sounds/evade2_10_game_over.mid")
end
