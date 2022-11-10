local gfx <const> = playdate.graphics

local screen
local currentScreen
local typewriterTimer
local holdTimer
local offset
local lineNumber

local SCREENS = {
  {"CRAFTED BY:", "MODUS CREATE", "DECEMBER 2017"},
  {"MUSIC AND SFX:", "J. GARCIA"},
  {"ART:", "M. TINTIUC", "JV DALEN", "JD JONES", "J. GARCIA"},
  {"PROGRAMMING:", "M. SCHWARTZ", "J. GARCIA", "M. TINTIUC"},
  {"PROGRAMMING:", "D. BRIGNOLI", "S. LEMMONS", "A. DENNIS"},
  {"PROGRAMMING:", "V. POPA", "L. STILL", "G. GRISOGONO"},
  {"PLAYDATE PORT:", "THIRTEEN37", "DECEMBER 2022"},
}

local next
local function typewriterUpdate(t)
  if offset < #(currentScreen[lineNumber]) then
    offset += 1
    PlaySound("next_attract_char")
  else
    if lineNumber < #currentScreen then
      offset = 0
      lineNumber += 1
    else
      t:remove()
      if not holdTimer then
        holdTimer = playdate.timer.new(2000, next)
      end
    end
  end
end

function next(t)
  offset = 0
  lineNumber = 1
  if typewriterTimer then
    typewriterTimer:remove()
    typewriterTimer = nil
  end
  if holdTimer then
    holdTimer:remove()
    holdTimer = nil
  end
  screen += 1
  if screen > #SCREENS then
    return MODE_SPLASH
  end
  currentScreen = SCREENS[screen]
  typewriterTimer = playdate.timer.new(100, typewriterUpdate)
  typewriterTimer.repeats = true
  PlaySound("next_attract_screen")
  PlaySound("next_attract_char")
end

function CreditsTypewriter()
  if playdate.buttonJustPressed(playdate.kButtonA) then
    return MODE_GAME
  end
  if playdate.buttonJustPressed(playdate.kButtonRight) then
    return next()
  end
  for i = 1, lineNumber-1 do
    FontPrintString(6, (i * 10) - 4, currentScreen[i], 0.9)
  end
  FontPrintString(6, (lineNumber * 10) - 4, currentScreen[lineNumber]:sub(1, offset), 0.9)
  if screen > #SCREENS then
    return MODE_SPLASH
  end
end

function CreditsEntry()
  screen = 0
  next()
end
