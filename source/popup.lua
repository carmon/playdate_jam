import 'CoreLibs/ui/gridview.lua'

import 'fontcache'

Popup = {}
Popup.__index = Popup

local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth = displayWidth/2

-- Texts
local GAME_TITLE <const> = 'WHEEL STORY' -- font reqs UPPER
local GAME_OVER <const> = 'GAME OVER' -- font reqs UPPER
local RELEASE_CRANK <const> = 'Release your crank to play'
local TEXT_START <const> = 'Press any button to start'
local TEXT_RETRY <const> = 'Press any button to retry'

function Popup:new()
  local self = {}

  local crankDocked
  function getSubtitleText()
    if crankDocked then return RELEASE_CRANK end
    if gameState == STATE_INIT then
      return TEXT_START
    else
      return TEXT_RETRY
    end
    return '[MISSING]'
  end

  function self:canClose()
    return not crankDocked
  end

  local bg
  local title
  local subtitle
  local listview
  local r
  
  function self:open()
    crankDocked = playdate.isCrankDocked()

    if bg == nil then
      local img = gfx.image.new(displayWidth, displayHeight)
      bg = gfx.sprite.new(img)
      bg:setImage(img)
      bg:moveTo(halfDisplayWidth, displayHeight/2)
    end
    local img = bg:getImage()
    gfx.pushContext(img)
      local w, h = bg:getSize()
      local margin = 40
      local m = margin*2
      gfx.setColor(gfx.kColorBlack)
      gfx.fillRect(margin,margin,w-m,h-m)
      local border = 5
      local b = border*2
      gfx.setColor(gfx.kColorWhite)
      gfx.fillRect(margin+border,margin+border,w-m-b,h-m-b)
    gfx.popContext()
    bg:add()

    local tStr do 
      if gameState == STATE_INIT then
        tStr = GAME_TITLE
      elseif gameState == STATE_OVER then
        tStr = GAME_OVER
      end
    end
    if title == nil then
      title = Textfield:new(halfDisplayWidth, 60, tStr)
      title:setFont(getFont('menu'))
    else 
      title:setField(tStr)
    end
    title:add()
    local sStr = getSubtitleText()
    if subtitle == nil then
      subtitle = Textfield:new(halfDisplayWidth, 180, sStr)
      subtitle:setFont(getFont('textfield'))
    else 
      subtitle:setField(sStr)
    end
    subtitle:add()
  end
  
  local subtitleTick = 0
  function self:update()
    local isDocked = playdate.isCrankDocked()
    if crankDocked ~= isDocked then
      crankDocked = isDocked
      subtitle:setField(getSubtitleText())
    end

    subtitleTick += 1
    if subtitleTick == 10 then
      subtitle:remove()
    elseif subtitleTick == 30 then
      subtitle:add()
      subtitleTick = 0
    end
  end

  function self:close()
    bg:remove()
    title:remove()
    subtitle:remove()
    subtitleTick = 0
  end

  return self
end