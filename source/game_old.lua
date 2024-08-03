import 'ball'
import 'segments'
import 'textfield'
import 'ui/speedmeter'

Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2

local START_DISTANCE = 625
local START_RADIUS = 50

CURRENT_SPEED = 0

function Game:new()
  local self = {}
  
  local radius

  local camPos
  local speed
  local distance
  local isDead

  local ball
  local speedUI
  local frictionTf

  local segments
  local segmentOffset
  local lastSegment

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
        segments:drawSegments(camPos)
        dirty = false
      end
    )

    segments = Segments:new()

    ball = Ball:new()

    speedUI = Speedmeter:new(halfDisplayWidth, displayHeight-25)
    speedUI:add()

    frictionTf = Textfield:new(halfDisplayWidth, 50, 'Friction')
    frictionTf:add()

    self:reset()
  end

  function self:reset()
    radius = START_RADIUS
    segments:addFirstSegmentBlock()
    ball:setRadius(radius)
    distance = START_DISTANCE
    lastSegment = segments:getSegmentAt(distance)
    segmentOffset = 1
    camPos = geo.point.new(0, 0) 
    speed = geo.point.new(0, 0)
    isDead = false
    dirty = true
  end

  function self:isDead()
    return isDead
  end

  function self:update()    
    if isDead then return end -- don't update if dead
    if playdate.isCrankDocked() then pauseGame() end -- this fn lives on main

    local initialPos = geo.point.new(ball:getPos()) 
    local newPos = initialPos
    local change = playdate.getCrankChange()
    local angle = 0 -- used in frinction calc
    if change ~= 0 then
      speed.x += change
    end

    local curr = segments:getSegmentAt(distance)
    if curr ~= nil then
      local x1, y1, x2, y2 = curr:unpack()
      angle = math.atan(y2-y1, x2-x1)
      newPos = curr:pointOnLine(distance - x1, false)
      newPos.y -= radius
    end

    local friction = radius/50
    local tan = math.tan(angle)
    speed.x += friction * tan
    frictionTf:setValue(friction * tan)
    if friction ~= 0 then
      -- radius -= math.abs(friction * tan)
      -- ball:setRadius(radius)
    end
    if speed.x < -MAX_SPEED then
      speed.x = -MAX_SPEED
    end
    if speed.x > MAX_SPEED then
      speed.x = MAX_SPEED
    end
    if speed.x ~= 0 then
      distance += speed.x
      ball:setSpeed(speed.x)
    end

    if curr ~= lastSegment then
      lastSegment = curr
      segmentOffset += 1
      if segmentOffset == 3 then
        segmentOffset -= 5
        segments:addNewSegmentBlock(speed.x > 0)
      end
    end

    if newPos.x ~= initialPos.x or newPos.y ~= initialPos.y then
      ball:setPos(newPos.x, newPos.y)
    end
    
    -- camera
    local newX = math.floor(newPos.x - halfDisplayWidth)
    local motion = false
    if newX ~= -camPos.x then
      camPos.x = -newX
      motion = true
    end
    local newY = newPos.y - (displayHeight-100)
    if newY ~= -camPos.y then
      camPos.y = -newY
      motion = true
    end
    
    if motion then
      gfx.setDrawOffset(camPos.x, camPos.y)
      gfx.sprite.redrawBackground()
      dirty = true
    end

    -- ui
    if speed.x ~= speedUI:getSpeed() then
      speedUI:setSpeed(speed.x)
      CURRENT_SPEED = speed.x
    end
    
    -- losing condition
    if radius <= 5 then
      camPos = geo.point.new(0, 0)
      gfx.setDrawOffset(0, 0)
      dirty = true
      isDead = true
    end
  end

  return self
end