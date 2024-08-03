import 'ball'

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

  local ball
  local shot = false

  local angle = 0
  
  local camPos
  local camDir = geo.point.new(0, 0)

  local dirty
  local isDead
  
  local myInputHandlers = {
    cranked = function (change)
      angle += change
      if angle >= 360 then angle = angle - 360 end
      if angle < 0 then angle = angle + 360 end
      dirty = true
      gfx.sprite.redrawBackground()
    end,
    AButtonDown = function ()
      local crankRads = math.rad(angle)
      camDir.x = math.sin(crankRads)
      camDir.y = -1 * math.cos(crankRads)
      ball:setDir(camDir.x, camDir.y)
      shot = true
    end,
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

  function self:start()
    playdate.inputHandlers.push(myInputHandlers) -- only pushed? somehow menu push overrides it
    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end

        local centerX = halfDisplayWidth-camPos.x
        local centerY = halfDisplayHeight-camPos.y

        setColor('dark')
        for i = 1, 10 do
          gfx.drawCircleAtPoint(centerX, centerY, i*100)
        end

        if not shot then
          local crankRads = math.rad(angle)
          local xOffset = math.sin(crankRads)
          local yOffset = -1 * math.cos(crankRads)
          gfx.drawLine(
            (30 * xOffset) + centerX, 
            (30 * yOffset) + centerY, 
            (80 * xOffset) + centerX,
            (80 * yOffset) + centerY
          )
        end

        dirty = false
      end
    )

    ball = Ball:new(halfDisplayWidth, halfDisplayHeight)

    self:reset()
  end

  function self:reset()
    camPos = geo.point.new(0, 0)
    isDead = false
    dirty = true
    gfx.setDrawOffset(0, 0)
  end

  function self:isDead()
    return isDead
  end

  function self:update()    
    if isDead then return end -- don't update if dead
    if playdate.isCrankDocked() then pauseGame() end -- this fn lives on main
    
    -- camera
    if camDir.x ~= 0 or camDir.y ~= 0 then
      camPos.x += camDir.x * CAM_SPEED
      camPos.y += camDir.y * CAM_SPEED
      gfx.setDrawOffset(-camPos.x, -camPos.y)
      gfx.sprite.redrawBackground()
      dirty = true
    end

    ball:update()
  end

  return self
end