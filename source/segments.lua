local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics
local _, displayHeight <const> = playdate.display.getSize()

local GAP_SEGMENTS <const> = 5
local MAX_SEGMENTS <const> = 10
local SEGMENT_LENGTH <const> = 250
local ANGLE_RANGE <const> = 0.015

Segments = {}
Segments.__index = Segments

function Segments:new()
  local self = {}

  local segments

  function addSegmentBlock()

  end

  function self:createFirstSegments()
    segments = {}
    local offset = 0
    local lineStart
    local h = displayHeight-50
    for i = 1, GAP_SEGMENTS do
      lineStart = offset*SEGMENT_LENGTH
      local ls = geo.lineSegment.new(lineStart, h, lineStart+SEGMENT_LENGTH, h)
      offset += 1
      table.insert(segments, ls)
    end

    -- add block 'mountain' 
    lineStart = offset*SEGMENT_LENGTH
    local a = -0.5
    local targetX = (SEGMENT_LENGTH * math.cos(a)) + lineStart
    local targetY = (SEGMENT_LENGTH * math.sin(a)) + h
    table.insert(segments, geo.lineSegment.new(lineStart, h, targetX, targetY))
    lineStart = targetX
    h = targetY
    targetX = (SEGMENT_LENGTH * math.cos(a)) + lineStart
    targetY = (SEGMENT_LENGTH * math.sin(a)) + h
    table.insert(segments, geo.lineSegment.new(lineStart, h, targetX, targetY))
    lineStart = targetX
    h = targetY
    table.insert(segments, geo.lineSegment.new(lineStart, h, lineStart+SEGMENT_LENGTH, h))
    lineStart = lineStart+SEGMENT_LENGTH
    a = 0.5
    targetX = (SEGMENT_LENGTH * math.cos(a)) + lineStart
    targetY = (SEGMENT_LENGTH * math.sin(a)) + h
    table.insert(segments, geo.lineSegment.new(lineStart, h, targetX, targetY))
    lineStart = targetX
    h = targetY
    targetX = (SEGMENT_LENGTH * math.cos(a)) + lineStart
    targetY = (SEGMENT_LENGTH * math.sin(a)) + h
    table.insert(segments, geo.lineSegment.new(lineStart, h, targetX, targetY))

    -- for i = 1, #segments do 
    --   print(segments[i])
    -- end
  end

  function self:getSegmentAt(x)
    for i = 1, #segments, 1 do
      local x1, _, x2 = segments[i]:unpack()
      if (x >= x1 and x <= x2) then return segments[i] end
    end
    return nil
  end

  local prevDir = 1
  local ang = 0
  function self:generateNewSegment(dir)
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
      end
    else
      local x, y, _,_ = segments[1]:unpack()
      local target = geo.lineSegment.new(
       (-SEGMENT_LENGTH * math.cos(ang)) + x, (SEGMENT_LENGTH * math.sin(ang)) + y,  x, y
      )
      table.insert(segments, 1, target) -- add first
      if #segments > MAX_SEGMENTS then
        table.remove(segments) -- remove last position
      end
    end
  end

  function self:drawSegments(camPos)
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

  return self
end