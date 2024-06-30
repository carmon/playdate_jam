import 'global'
import 'pop'
import 'player'
import 'textfield'

Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
local displayWidth <const>, displayHeight <const> = playdate.display.getSize()
local halfDisplayWidth <const> = displayWidth/2

local RADIUS <const> = 15
local FRICTION <const> = 10
local MAX_SPEED <const> = 40
local JUMP_SPEED <const> = 15
local DIE_LINE <const> = displayHeight*10
local GRAVITY <const> = 5

function Game:new()
  local self = {}

  local cameraX = 0
  local cameraY = 0
  local lastCameraY = 0
  local yAnchor

  local distance = 0
  local speed = geo.point.new(0, 0)
  local isFalling = false
  local isDead = false

  local player

  local speedUI
  local versionUI
  local pop -- temp: replaces angleUI

  -- temp
  local angle = 0

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
  
  -- Dynamic segment gen
  local lineWidth = 150
  local MAX_CURVE = 35

  local dir = -MAX_CURVE
  function self:temp()
    dir = -dir
  end
  
  function generateNewSegment()
    local last = segments[#segments]
    local _, _, x,y = last:unpack()
    local dynamicY = y+math.random(-MAX_CURVE, MAX_CURVE)
    -- MAX_CURVE += 1
    local target = geo.lineSegment.new(x, y, x+lineWidth, dynamicY)
    table.insert(segments, target)
  end

  local dirty = true
  function self:start()
    -- Add two first segments
    local offset = 0
    local lineStart
    local h = displayHeight-50
    for i = 1, 3 do
      lineStart = offset*lineWidth
      local ls = geo.lineSegment.new(lineStart, h, lineStart+lineWidth, h)
      offset += 1
      table.insert(segments, ls)
    end
    yAnchor = h-RADIUS

    -- Only way to draw segments and sprites
    gfx.sprite.setBackgroundDrawingCallback(
      function(x, y, width, height)
        if not dirty then return end
        for i = 1, #segments do
          if getmetatable(segments[i]) == geo.lineSegment then
            local x1, y1, x2, y2 = segments[i]:unpack()
            local y do
              if not isFalling then 
                y = cameraY 
              else 
                y = lastCameraY
              end
            end
            gfx.drawLine(geo.lineSegment.new(x1+cameraX, y1+y, x2+cameraX, y2+y))
            angle = math.atan(y2-y1, x2-x1)
            local cX = x2+cameraX
            local cY = y2+y
            local line = geo.lineSegment.new(
              math.sin(angle) * 10 + cX,
              -math.cos(angle) * 10 + cY, 
              -math.sin(angle) * 10 + cX, 
              math.cos(angle) * 10 + cY
            )
            gfx.drawLine(line)
          elseif getmetatable(segments[i]) == geo.arc then
            gfx.drawArc(segments[i])
          end
        end
        dirty = false
      end
    )

    player = Player(0, 0, RADIUS)
    player:add()

    pop = Pop(halfDisplayWidth, 30, 150, 50)
    pop:add()

    local font = gfx.font.new('font/whiteglove-stroked')
    
    speedUI = Textfield:new(50, displayHeight-20, 'Speed')
    speedUI:setFont(font)
    speedUI:add()

    versionUI = Textfield:new(displayWidth-30, 10, '0.03b.1')
    versionUI:setFont(font)
    versionUI:add()
  end

  function self:reset()
    cameraY = 0
    speed = geo.point.new(0, 0)
    distance = 0
    player:moveTo(0, 0)
    isFalling = false
    isDead = false
  end

  function self:action()
    if not isFalling and not isDead then
      isFalling = true
      lastCameraY = cameraY
      speed.y = JUMP_SPEED
    end
  end

  function self:isDead()
    return isDead
  end

  -- temp
  local lastSegment = 1
  function self:update()
    local newPos = geo.point.new(player.x, player.y)
    if not isDead then
      local change = playdate.getCrankChange()
      if change ~= 0 then
        speed.x += change
      end

      if speed.x > 0 then
        speed.x += FRICTION * math.tan(angle)
      end
      if speed.x < 0 then
        speed.x = 0
      end
      if speed.x > MAX_SPEED then
        speed.x = MAX_SPEED
      end

      distance += speed.x
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
          end
          local s = segments[curr]
          local x = s:unpack()
          if getmetatable(s) == geo.lineSegment then
            newPos = s:pointOnLine(distance - x, false)
          elseif getmetatable(s) == geo.arc then
            newPos = s:pointOnArc(distance - x, false)
          end
          newPos.y -= RADIUS
        else
          isFalling = true
        end
      end
    end

    if newPos.y > DIE_LINE then
      isDead = true
      return
    end

    -- camera
    local newX = math.floor(math.max(0, newPos.x - halfDisplayWidth + 60))
    local motion = false
    if newX ~= -cameraX then
      cameraX = -newX
      motion = true
    end
    local newY = newPos.y - yAnchor
    if newY ~= -cameraY then
      cameraY = -newY
      motion = true
    end
    
    if motion then
      local y do
        if not isFalling then 
          y = cameraY 
        else 
          y = lastCameraY
        end
      end
      gfx.setDrawOffset(cameraX, y)
      gfx.sprite.redrawBackground()
      dirty = true
    end

    -- player
    if newPos.x ~= player.x or newPos.y ~= player.y then
      player:moveTo(newPos.x, newPos.y)
      player:nextFrame()
    end

    -- ui
    pop:setAngle(angle)
    speedUI:setValue(speed.x)
  end

  return self
end