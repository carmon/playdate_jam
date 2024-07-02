import 'CoreLibs/nineslice' -- temporary

Menu = {}
Menu.__index = Menu

local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth = displayWidth/2

function Menu:new()
  local self = {}

  local slice
  local title
  local subtitle
  local subtitleTick = 0
  function self:open()
    local tStr, sStr
    if gameState == STATE_INIT then
      tStr = 'WHEEL STORY'
      sStr = 'Press any button to start'
    elseif gameState == STATE_OVER then
      tStr = 'GAME OVER'
      sStr = 'Press any button to reset'
    end
    if slice == nil then
      slice = gfx.nineSlice.new('images/platform', 3, 3, 13, 4)
    end
    -- this doesn't display a second time :/
    slice:drawInRect(80, 40, displayWidth-160, 160)
    if title == nil then
      title = Textfield:new(halfDisplayWidth, 60, tStr)
      title:setFont(gfx.font.new('font/Parodius Da!'))
    else 
      title:setField(tStr)
    end
    title:add()
    if subtitle == nil then
      subtitle = Textfield:new(halfDisplayWidth, 140, sStr)
    else 
      subtitle:setField(sStr)
    end
    subtitle:add()
  end
  
  function self:update()
    subtitleTick += 1
    if subtitleTick == 30 then
      subtitle:remove()
    elseif subtitleTick == 60 then
      subtitle:add()
      subtitleTick = 0
    end
  end

  function self:close()
    title:remove()
    subtitle:remove()
  end

  return self
end