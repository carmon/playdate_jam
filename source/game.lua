Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2
local halfDisplayHeight <const> = displayHeight/2

local CAM_SPEED = 5

function Game:new()
  local self = {}
  
  local camPos
  local camDir = geo.point.new(0, 0)

  local isDead
  
  local myInputHandlers = {
    upButtonDown = function ()
      camDir.y -= 1
    end,
    upButtonUp = function ()
      camDir.y += 1
    end,
    downButtonDown = function ()
      camDir.y += 1
    end,
    downButtonUp = function ()
      camDir.y -= 1
    end,
    leftButtonDown = function ()
      camDir.x -= 1
    end,
    leftButtonUp = function ()
      camDir.x += 1
    end,
    rightButtonDown = function ()
      camDir.x += 1
    end,
    rightButtonUp = function ()
      camDir.x -= 1
    end
  }

  local dirty
  function self:start()
    playdate.inputHandlers.push(myInputHandlers) -- only pushed? somehow menu push overrides it
    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end
        setColor('dark')
        gfx.fillCircleAtPoint(halfDisplayWidth, halfDisplayHeight, 50)
        gfx.drawCircleAtPoint(halfDisplayWidth, halfDisplayHeight, 400)
        dirty = false
      end
    )

    self:reset()
  end

  function self:reset()
    camPos = geo.point.new(0, 0)
    isDead = false
    dirty = true
    gfx.setDrawOffset(-20, -10)
  end

  function self:isDead()
    return isDead
  end

  function self:update()    
    if isDead then return end -- don't update if dead
    if playdate.isCrankDocked() then pauseGame() end -- this fn lives on main

    print(gfx.getDrawOffset())
    
    -- camera
    if camDir.x ~= 0 or camDir.y ~= 0 then
      camPos.x += camDir.x * CAM_SPEED
      camPos.y += camDir.y * CAM_SPEED
      gfx.setDrawOffset(-camPos.x, -camPos.y)
      gfx.sprite.redrawBackground()
      dirty = true
    end
  end

  return self
end