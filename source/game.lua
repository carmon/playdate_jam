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

-- Segment Gen
local SEGMENT_LENGTH = 250
local START_RADIUS = 50

CURRENT_SPEED = 0

function Game:new()
  local self = {}
  
  local radius

  -- reset & start assignments 
  local camPos
  local speed
  local distance
  local isDead

  -- sprites or sprite containers
  local ball
  local speedUI
  local frictionTf

  -- temp
  local lastSegment = 1

  -- segments start
  local segments
  function getSegmentAtDistance()
    for i = 1, #segments, 1 do
      local x1, _, x2 = segments[i]:unpack()
      if (distance >= x1 and distance <= x2) then return i end
    end
    return 0 -- pun intended
  end

  local MAX_SEGMENTS = 5
  local prevDir = 1
  local ang = 0
  local ANGLE_RANGE = 0.015
  function generateNewSegment(dir)
    if dir ~= prevDir then
      ang = 0
      prevDir = dir
    end
    ang = ang+(math.random(-1, 1)*ANGLE_RANGE)
    if dir > 0 then
      local _, _, x,y = segments[#segments]:unpack()
      local target = geo.lineSegment.new(
        x, y, (SEGMENT_LENGTH * math.cos(ang)) + x, (SEGMENT_LENGTH * math.sin(ang)) + y
      )
      table.insert(segments, target) -- add last
      if #segments > MAX_SEGMENTS then
        table.remove(segments, 1) -- remove first position
        lastSegment -= dir
      end
    else
      local x, y, _,_ = segments[1]:unpack()
      local target = geo.lineSegment.new(
       (-SEGMENT_LENGTH * math.cos(ang)) + x, (SEGMENT_LENGTH * math.sin(ang)) + y,  x, y
      )
      table.insert(segments, 1, target) -- add first
      if #segments > MAX_SEGMENTS then
        table.remove(segments) -- remove last position
        lastSegment -= dir
      end
    end
  end

  function drawSegments()
    for i = 1, #segments do
      local x1, y1, x2, y2 = segments[i]:unpack()
      setColor('dark')
      gfx.drawLine(geo.lineSegment.new(x1+camPos.x, y1+camPos.y, x2+camPos.x, y2+camPos.y))
      local angle = math.atan(y2-y1, x2-x1)
      local cX = x2+camPos.x
      local cY = y2+camPos.y
      local line = geo.lineSegment.new(
        math.sin(angle) * 10 + cX,
        -math.cos(angle) * 10 + cY, 
        -math.sin(angle) * 10 + cX, 
        math.cos(angle) * 10 + cY
      )
      gfx.drawLine(line)
    end
  end
  -- segments end

  local myInputHandlers = {
    AButtonUp = function()
      radius += 1
      ball:setRadius(radius)
    end,

    BButtonUp = function()
      radius += 1
      ball:setRadius(radius)
    end,
  }

  local dirty
  function self:start()
    playdate.inputHandlers.push(myInputHandlers) -- only pushed? somehow menu push overrides it
    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end
        drawSegments()
        dirty = false
      end
    )

    ball = Ball:new()

    speedUI = Speedmeter:new(halfDisplayWidth, displayHeight-25)
    speedUI:add()

    frictionTf = Textfield:new(halfDisplayWidth, 50, 'Friction')
    frictionTf:add()

    self:reset()
  end

  function self:reset()
    radius = START_RADIUS
    segments = createFirstSegments()
    ball:setRadius(radius)
    distance = SEGMENT_LENGTH * 2.5
    camPos = geo.point.new(0, 0) 
    speed = geo.point.new(0, 0)
    isDead = false
    dirty = true
  end

  function self:isDead()
    return isDead
  end

  function self:update()
    -- don't update if dead
    if isDead then return end

    local initialPos = geo.point.new(ball:getPos()) 
    local newPos = initialPos
    local change = playdate.getCrankChange()
    local angle = 0 -- used in frinction calc
    if change ~= 0 then
      speed.x += change
    end

    local curr = getSegmentAtDistance()
    if curr > 0 then
      if curr ~= lastSegment then
        local dir do
          if curr > lastSegment then
            dir = 1
          else 
            dir = -1
          end
        end
        lastSegment = curr
        generateNewSegment(dir)
      end
      local s = segments[curr]
      local x1, y1, x2, y2 = s:unpack()
      angle = math.atan(y2-y1, x2-x1)
      newPos = s:pointOnLine(distance - x1, false)
      newPos.y -= radius
    end

    -- modify speed according to angle of slope
    local friction = radius/10
    local tan = math.tan(angle)
    speed.x += friction * tan
    frictionTf:setValue(friction * tan)
    if friction ~= 0 then
      radius -= math.abs(friction * tan)
      ball:setRadius(radius)
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

    -- camera
    local newX = math.floor(newPos.x - halfDisplayWidth)
    local motion = false
    if newX ~= -camPos.x then
      camPos.x = -newX
      motion = true
    end
    local newY = newPos.y - (displayHeight-100)
    if newY ~= -camPos.x then
      camPos.y = -newY
      motion = true
    end
    
    if motion then
      gfx.setDrawOffset(camPos.x, camPos.y)
      gfx.sprite.redrawBackground()
      dirty = true
    end

    if newPos.x ~= initialPos.x or newPos.y ~= initialPos.y then
      ball:setPos(newPos.x, newPos.y)
    end
    
    -- ui
    if speed.x ~= speedUI:getSpeed() then
      speedUI:setSpeed(speed.x)
      CURRENT_SPEED = speed.x
    end
    
    -- losing condition
    if radius <= 1 then
      camPos = geo.point.new(0, 0)
      gfx.setDrawOffset(0, 0)
      dirty = true
      isDead = true
    end
  end

  return self
end