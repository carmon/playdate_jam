local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()

local darkMode = false
function getDarkMode()
  return darkMode
end
function setDarkMode(value)
  if darkMode ~= value then
    darkMode = value
    if darkMode then
      gfx.setBackgroundColor(gfx.kColorBlack)
    else
      gfx.setBackgroundColor(gfx.kColorWhite)
    end
  end
end
function setColor(v)
  if v == 'dark' then
    if darkMode then
      gfx.setColor(gfx.kColorWhite)
    else
      gfx.setColor(gfx.kColorBlack)
    end
  else 
    if darkMode then
      gfx.setColor(gfx.kColorBlack)
    else
      gfx.setColor(gfx.kColorWhite)
    end
  end
end