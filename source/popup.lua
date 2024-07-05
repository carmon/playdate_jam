import 'ui/menu'

Popup = {}
Popup.__index = Popup

local gfx <const> = playdate.graphics
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth = displayWidth/2

-- Texts
local DEFAULT_MENU = {"Option"}
local OPTIONS_MENU = {"Dark mode", "Back"}
local STATE_DEFAULT = 1
local STATE_OPTIONS = 2

local ALERT_CRANK <const> = 'RELEASE the CRANK to PLAY'

function Popup:new(startGame)
  local self = {}

  local crankDocked

  local bg
  local title

  -- temp menu ui
  local menuState = STATE_DEFAULT
  local defaultMenu
  local optionsMenu

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
      if menuState == STATE_DEFAULT then
        if selection == 1 and startGameHandler ~= nil then
          startGameHandler()
        end
        if selection == 2 then
          defaultMenu:remove()
          optionsMenu:add()
          menuState = STATE_OPTIONS
        end
      elseif menuState == STATE_OPTIONS then
        if selection == 1 then
          local dm = not getDarkMode()
          setDarkMode(dm)
          optionsMenu:setValue(1, dm)
          self:drawBg()
          defaultMenu:draw()
          optionsMenu:draw()
        end

        if selection == 2 then
          optionsMenu:remove()
          defaultMenu:add()
          menuState = STATE_DEFAULT
        end
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
        selection = #DEFAULT_MENU
      end
      if menuState == STATE_DEFAULT then
        defaultMenu:setSelection(selection)
      elseif menuState == STATE_OPTIONS then
        optionsMenu:setSelection(selection)
      end
    end,

    downButtonUp = function()
      selection += 1
      if selection > #DEFAULT_MENU then 
        selection = 1
      end
      if menuState == STATE_DEFAULT then
        defaultMenu:setSelection(selection)
      elseif menuState == STATE_OPTIONS then
        optionsMenu:setSelection(selection)
      end
    end,
  }

  function self:drawBg()
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
  end
  
  function self:open(titleStr, action)
    playdate.inputHandlers.push(myInputHandlers)

    crankDocked = playdate.isCrankDocked()

    if bg == nil then
      local img = gfx.image.new(displayWidth, displayHeight)
      bg = gfx.sprite.new(img)
      bg:setImage(img)
      bg:moveTo(halfDisplayWidth, displayHeight/2)
    end
    self:drawBg()
    bg:add()

    if title == nil then
      title = Textfield:new(halfDisplayWidth, 70, titleStr)
    else 
      title:setField(titleStr)
    end
    title:add()

    table.insert(DEFAULT_MENU, 1, action)
    defaultMenu = Menu:new(halfDisplayWidth, 80, DEFAULT_MENU, selection)
    defaultMenu:add()

    optionsMenu = Menu:new(halfDisplayWidth, 80, OPTIONS_MENU, #OPTIONS_MENU)
    optionsMenu:setValue(1, getDarkMode())

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
    defaultMenu:remove()
    table.remove(DEFAULT_MENU, 1)
    alert:remove()
    alertTick = 0
  end

  return self
end