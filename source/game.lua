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
      ball:setDir(math.sin(crankRads), -1 * math.cos(crankRads))
      shot = true
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
        for i = 1, 1 do
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
    if shot then
      -- print('update -> camDir ', camDir)
      local bX, bY = ball:getPos()
      -- print('update -> ball:getPos ', bX, bY)
      local target = geo.point.new(bX - halfDisplayWidth, bY - halfDisplayHeight)
      -- print('update -> tmpPoint ', tmpPoint)
      local lerp = 0.85
      camPos.x = camPos.x * (1 - lerp) + target.x * lerp
      camPos.y = camPos.y * (1 - lerp) + target.y * lerp
      -- print('update -> gfx.setDrawOffset ', camPos)
      gfx.setDrawOffset(-camPos.x, -camPos.y)
      gfx.sprite.redrawBackground()
      dirty = true

      local cageCenterX = halfDisplayWidth-camPos.x
      local cageCenterY = halfDisplayHeight-camPos.y

      local rightX = cageCenterX + 200
      local leftX = cageCenterX - 200
      local topY = cageCenterY - 200
      local bottomY = cageCenterY + 200

      local bRadius = 12.5
      if bX-bRadius <= leftX or bX+bRadius >= rightX or bY+bRadius >= bottomY or bY-bRadius <= topY then
        local dir = ball:getDir()
        local dirX = -dir.x
        local dirY = -dir.y
        ball:setPos(bX+(10*dirX), bY+(10*dirY))
        ball:setDir(dirX, dirY)
      end
    end
    ball:update()

  end

  return self
end