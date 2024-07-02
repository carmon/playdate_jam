import 'global'
import 'pop'
import 'player'
import 'textfield'
import 'speedUI'

Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2

-- Segment Gen
local SEGMENT_LENGTH = 250

-- Ball stuff
local RADIUS <const> = 15
local FRICTION <const> = 2

-- temp
local DIE_LINE <const> = displayHeight*10

-- Jump stuff
local JUMP_SPEED <const> = 15
local GRAVITY <const> = 5

CURRENT_SPEED = 0

function Game:new()
  local self = {}

  local camPos = geo.point.new(0, 0) 
  local lastCameraY = 0
  local yAnchor

  local distance = SEGMENT_LENGTH
  local speed = geo.point.new(0, 0)
  local isFalling = false
  local isDead = false

  local player
  local speedUI

  -- temp
  local totalSegmentsTf
  local pop 

  -- segments start
  local segments = {} -- set the empty table
  function getSegmentAtX(x) -- getter
    for i = 1, #segments, 1 do
      local x1, _, x2 = segments[i]:unpack()
      if (x >= x1 and x <= x2) then return segments[i] end
    end
    return nil
  end
  function getPosAtDistance() -- getter
    for i = 1, #segments, 1 do
      local x1, _, x2 = segments[i]:unpack()
      if (distance >= x1 and distance <= x2) then return i end
    end
    return 0 -- pun intended
  end
  
  -- temp function, called when B button is pressed
  local showSlope = true
  function self:temp()
    showSlope = not showSlope
    if showSlope then
      pop:add()
    else
      pop:remove()
    end
  end
  
  -- Dynamic segment gen
  local lastPoint
  local ang = 0
  local ANGLE_RANGE = 0.015
  function generateNewSegment()
    local x,y = lastPoint:unpack()
    ang = ang+(math.random(-1, 1)*ANGLE_RANGE)
    
    lastPoint.x = (SEGMENT_LENGTH * math.cos(ang)) + x
    lastPoint.y = (SEGMENT_LENGTH * math.sin(ang)) + y

    local target = geo.lineSegment.new(x, y, lastPoint.x, lastPoint.y)
    table.insert(segments, target)
  end

  local dirty = true
  function self:start()
    -- Add first segments
    local offset = 0
    local lineStart
    local h = displayHeight-50
    for i = 1, 3 do
      lineStart = offset*SEGMENT_LENGTH
      local ls = geo.lineSegment.new(lineStart, h, lineStart+SEGMENT_LENGTH, h)
      offset += 1
      table.insert(segments, ls)
    end
    lastPoint = geo.point.new(lineStart+SEGMENT_LENGTH, h) -- for segment gen
    yAnchor = h-RADIUS -- for camera use

    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end
        for i = 1, #segments do
          local x1, y1, x2, y2 = segments[i]:unpack()
          local y do
            if not isFalling then 
              y = camPos.y
            else 
              y = lastCameraY
            end
          end
          gfx.drawLine(geo.lineSegment.new(x1+camPos.x, y1+y, x2+camPos.x, y2+y))
          local angle = math.atan(y2-y1, x2-x1)
          local cX = x2+camPos.x
          local cY = y2+y
          local line = geo.lineSegment.new(
            math.sin(angle) * 10 + cX,
            -math.cos(angle) * 10 + cY, 
            -math.sin(angle) * 10 + cX, 
            math.cos(angle) * 10 + cY
          )
          gfx.drawLine(line)
        end
        dirty = false
      end
    )

    player = Player(RADIUS)
    player:add()

    pop = Pop(halfDisplayWidth, 30, 150, 50)
    pop:add()

    speedUI = SpeedUI:new(halfDisplayWidth, displayHeight-25)
    speedUI:add()

    totalSegmentsTf = Textfield:new(halfDisplayWidth, 80, 'Total Segments', #segments)
    totalSegmentsTf:add()
  end

  function self:reset()
    distance = SEGMENT_LENGTH
    camPos = geo.point.new(0, 0) 
    speed = geo.point.new(0, 0)
    isFalling = false
    isDead = false
    dirty = true
  end

  function self:action()
    if not isFalling and not isDead then
      isFalling = true
      lastCameraY = camPos.y
      speed.y = JUMP_SPEED
    end
  end

  function self:isDead()
    return isDead
  end

  -- temp
  local lastSegment = 1
  function self:update()
    -- don't update if dead
    if isDead then return end

    local newPos = geo.point.new(player.x, player.y)
    local change = playdate.getCrankChange()
    local angle = 0 -- used in pop
    if change ~= 0 then
      speed.x += change
    end

    if isFalling then
      newPos.x += speed.x
      newPos.y -= speed.y

      speed.y -= GRAVITY

      local segment = getSegmentAtX(newPos.x)
      if segment ~= nil then
        local r = geo.rect.new(newPos.x-RADIUS, newPos.y-RADIUS, RADIUS*2, RADIUS*2)
        isFalling = not segment:intersectsRect(r)
      end
    else 
      local curr = getPosAtDistance()
      if curr > 0 then
        if curr > lastSegment then
          generateNewSegment()
          lastSegment = curr
          totalSegmentsTf:setValue(#segments)
        end
        local s = segments[curr]
        local x1, y1, x2, y2 = s:unpack()
        angle = math.atan(y2-y1, x2-x1) -- calc angle for pop
        newPos = s:pointOnLine(distance - x1, false)
        newPos.y -= RADIUS
      else
        isFalling = true
      end
    end

    -- modify speed according to slope
    speed.x += FRICTION * math.tan(angle)
    if speed.x < -MAX_SPEED then
      speed.x = -MAX_SPEED
    end
    if speed.x > MAX_SPEED then
      speed.x = MAX_SPEED
    end
    distance += speed.x

    -- camera
    local newX = math.floor(math.max(0, newPos.x - halfDisplayWidth + 60))
    local motion = false
    if newX ~= -camPos.x then
      camPos.x = -newX
      motion = true
    end
    local newY = newPos.y - yAnchor
    if newY ~= -camPos.x then
      camPos.y = -newY
      motion = true
    end
    
    if motion then
      local y do
        if not isFalling then 
          y = camPos.y 
        else 
          y = lastCameraY
        end
      end
      gfx.setDrawOffset(camPos.x, y)
      gfx.sprite.redrawBackground()
      dirty = true
    end

    -- player
    if newPos.x ~= player.x or newPos.y ~= player.y then
      player:moveTo(newPos.x, newPos.y)
    end

    -- ui
    if angle ~= pop:getAngle() then
      pop:setAngle(angle)
    end
    if speed.x ~= speedUI:getSpeed() then
      speedUI:setSpeed(speed.x)
      CURRENT_SPEED = speed.x
    end
    
    -- losing condition
    if newPos.y > DIE_LINE then
      camPos = geo.point.new(0, 0)
      gfx.setDrawOffset(0, 0)
      isFalling = false
      isDead = true
      dirty = true
    end
  end

  return self
end