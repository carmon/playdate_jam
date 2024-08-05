Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2
local halfDisplayHeight <const> = displayHeight/2

-- Moving ball shit here
local BALL_RADIUS = 15;
local BALL_SPEED = 5;

function Game:new()
  local self = {}

  local shot = false

  local angle = 0
  
  local camPos

  local dirty
  local isDead

  local ballDir = geo.point.new(0, 0)
  
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
      ballDir.x = math.sin(crankRads)
      ballDir.y = -1 * math.cos(crankRads)
      shot = true
    end
  }

  local ballSprite
  function self:start()
    playdate.inputHandlers.push(myInputHandlers) -- only pushed? somehow menu push overrides it
    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end

        local centerX = halfDisplayWidth-camPos.x
        local centerY = halfDisplayHeight-camPos.y

        setColor('dark')
        for i = 1, 1 do
          gfx.drawCircleAtPoint(centerX, centerY, i*100)
        end
        
        if not shot then
          local bX, bY = ballSprite:getPosition()
          local crankRads = math.rad(angle)
          local xOffset = math.sin(crankRads)
          local yOffset = -1 * math.cos(crankRads)
          gfx.drawLine(
            (30 * xOffset) + bX-camPos.x, 
            (30 * yOffset) + bY-camPos.y, 
            (80 * xOffset) + bX-camPos.x,
            (80 * yOffset) + bY-camPos.y
          )
        end

        dirty = false
      end
    )

    local ballImg = gfx.image.new(BALL_RADIUS*2,BALL_RADIUS*2)
    ballSprite = gfx.sprite.new(ballImg)
    gfx.pushContext(ballImg)
      setColor('dark')
      gfx.fillCircleAtPoint(BALL_RADIUS, BALL_RADIUS, BALL_RADIUS)
    gfx.popContext()
    ballSprite:add()
    ballSprite:moveTo(halfDisplayWidth, halfDisplayHeight)

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
  
    if ballDir.x ~= 0 or ballDir.y ~= 0 then
      local bX, bY = ballSprite:getPosition()
      local cageCenterX = halfDisplayWidth --camPos.x
      local cageCenterY = halfDisplayHeight --camPos.y

      local distSq = math.sqrt(((bX-cageCenterX)*(bX-cageCenterX))+((bY-cageCenterY)*(bY-cageCenterY)))

      -- local lerp = 0.85
      -- local target = geo.point.new(bX - halfDisplayWidth, bY - halfDisplayHeight)
      -- camPos.x = camPos.x * (1 - lerp) + target.x * lerp
      -- camPos.y = camPos.y * (1 - lerp) + target.y * lerp
      -- gfx.setDrawOffset(-camPos.x, -camPos.y)
      -- gfx.sprite.redrawBackground()

      if distSq + BALL_RADIUS >= 100 then
        local dirX = -ballDir.x
        local dirY = -ballDir.y
        ballSprite:moveTo(bX+(10*dirX), bY+(10*dirY))
        ballDir.x = dirX
        ballDir.y = dirY
        shot = false
      else
        ballSprite:moveTo(bX + ballDir.x * BALL_SPEED, bY + ballDir.y * BALL_SPEED)
      end
      gfx.sprite.redrawBackground()
      dirty = true
    end

  end

  return self
end