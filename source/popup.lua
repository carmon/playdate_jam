import 'ui/menu'

Popup = {}
Popup.__index = Popup

local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth = displayWidth/2

-- Texts
local GAME_TITLE <const> = 'WHEEL STORY'
local GAME_OVER <const> = 'Game Over'

local START_OPTIONS = {"Start Game", "Option"}

local ALERT_CRANK <const> = 'RELEASE the CRANK to PLAY'

function Popup:new(startGame)
  local self = {}

  local crankDocked
  function self:canClose()
    return not crankDocked
  end

  local bg
  local title
  local menu

  local alert
  local listview
  local r
  
  local selection = 1
  local showTick = false

  local startGameHandler = nil
  function self:setStartGameHandler(value)
    startGameHandler = value
  end

  local myInputHandlers = {
    AButtonUp = function()
      if crankDocked then
        showTick = true
        return
      end
      if selection == 1 and startGameHandler ~= nil then
        startGameHandler()
      end
    end,

    BButtonUp = function()
      if crankDocked then
        showTick = true
        return
      end
    end,

    upButtonUp = function()
      selection -= 1
      if selection == 0 then 
        selection = #START_OPTIONS
      end
      menu:setSelection(selection)
    end,

    downButtonUp = function()
      selection += 1
      if selection > #START_OPTIONS then 
        selection = 1
      end
      menu:setSelection(selection)
    end,
  }
  
  function self:open()
    playdate.inputHandlers.push(myInputHandlers)

    crankDocked = playdate.isCrankDocked()

    if bg == nil then
      local img = gfx.image.new(displayWidth, displayHeight)
      bg = gfx.sprite.new(img)
      bg:setImage(img)
      bg:moveTo(halfDisplayWidth, displayHeight/2)
    end
    local img = bg:getImage()
    local w, h = bg:getSize()
    local margin = 40
    local m = margin*2
    gfx.pushContext(img)
      setColor('dark')
      gfx.fillRoundRect(m,margin,w-m*2,h-m, 4)
      local border = 2
      local b = border*2
      setColor('light')
      gfx.fillRoundRect(m+border,margin+border,w-m*2-b,h-m-b, 4)
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
      title = Textfield:new(halfDisplayWidth, 70, tStr)
    else 
      title:setField(tStr)
    end
    title:add()

    menu = Menu:new(halfDisplayWidth, 80, START_OPTIONS, selection)
    menu:add()

    if alert == nil then
      alert = Textfield:new(halfDisplayWidth, 180, ALERT_CRANK)
    else 
      alert:setField(sStr)
    end
    if crankDocked then
      alert:add()
    end
  end
  
  local alertTick = 0
  function self:update()
    local isDocked = playdate.isCrankDocked()
    if crankDocked ~= isDocked then
      crankDocked = isDocked
      if isDocked then
        alert:add()
      else
        alert:remove()
      end
    end

    if showTick then
      alertTick += 1
      if alertTick == 1 then
        alert:remove()
      elseif alertTick == 11 then
        alert:add()
      elseif alertTick == 21 then
        alert:remove()
      elseif alertTick == 31 then
        showTick = false
        alertTick = 0
        alert:add()
      end
    end
  end

  function self:close()
    playdate.inputHandlers.pop()

    bg:remove()
    title:remove()
    menu:remove()
    alert:remove()
    alertTick = 0
  end

  return self
end