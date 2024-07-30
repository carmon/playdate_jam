Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2

function Game:new()
  local self = {}
  
  local camPos
  local isDead

  local press = function()
    ball:setSlide(true)
  end

  local up = function()
    ball:setSlide(false)
  end

  local myInputHandlers = {
    AButtonDown = press,
    BButtonDown = press,
    AButtonUp = up,
    BButtonUp = up,
  }

  local dirty
  function self:start()
    playdate.inputHandlers.push(myInputHandlers) -- only pushed? somehow menu push overrides it
    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end
        dirty = false
      end
    )

    self:reset()
  end

  function self:reset()
    camPos = geo.point.new(0, 0) 
    isDead = false
    dirty = true
  end

  function self:isDead()
    return isDead
  end

  function self:update()    
    if isDead then return end -- don't update if dead
    if playdate.isCrankDocked() then pauseGame() end -- this fn lives on main
    
    -- camera
    -- local newX = math.floor(newPos.x - halfDisplayWidth)
    -- local motion = false
    -- if newX ~= -camPos.x then
    --   camPos.x = -newX
    --   motion = true
    -- end
    -- local newY = newPos.y - (displayHeight-100)
    -- if newY ~= -camPos.y then
    --   camPos.y = -newY
    --   motion = true
    -- end
    
    -- if motion then
    --   gfx.setDrawOffset(camPos.x, camPos.y)
    --   gfx.sprite.redrawBackground()
    --   dirty = true
    -- end
  end

  return self
end