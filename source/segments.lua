local geo <const> = playdate.geometry
local gfx <const> = playdate.graphics
local _, displayHeight <const> = playdate.display.getSize()

local GAP_SEGMENTS <const> = 5
local MAX_SEGMENTS <const> = 20
local SEGMENT_LENGTH <const> = 250
local ANGLE_RANGE <const> = 0.015

local BLOCK_LIST <const> = {
  {-0.5, -0.25, 0, 0.25, 0.5}, -- mountain
  {0.5, -0.5, 0, 0.5, -0.5}, -- 2 peaks
  {0, -0.75, 0, 0.75, 0},
  {0.75, -0.75, 0.75, -0.75, 0},
  {0, 0, 0, 0, 0},
  {0.3, 0.3, 0, -0.3, -0.3}
}

Segments = {}
Segments.__index = Segments

function Segments:new()
  local self = {}

  local segments

  function self:addFirstSegmentBlock()
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
  end

  function self:getSegmentAt(x)
    for i = 1, #segments, 1 do
      local x1, _, x2 = segments[i]:unpack()
      if (x >= x1 and x <= x2) then return segments[i] end
    end
    return nil
  end

  function self:addNewSegmentBlock(movesRight)
    local angles = BLOCK_LIST[math.random(#BLOCK_LIST)]
    local inverse = math.random() > 0.5
    if movesRight then
      if #segments == MAX_SEGMENTS then
        repeat
          table.remove(segments, 1)
        until #segments == MAX_SEGMENTS - GAP_SEGMENTS
      end
      local _, _, x, y = segments[#segments]:unpack()
      for i = 1, GAP_SEGMENTS do
        local a do 
          if inverse then 
            a = -angles[i]
          else
            a = angles[i]
          end
        end
        local targetX = (SEGMENT_LENGTH * math.cos(a)) + x
        local targetY = (SEGMENT_LENGTH * math.sin(a)) + y
        table.insert(segments, geo.lineSegment.new(x, y, targetX, targetY))
        x = targetX
        y = targetY
      end
    else
      if #segments == MAX_SEGMENTS then
        repeat
          table.remove(segments)
        until #segments == MAX_SEGMENTS - GAP_SEGMENTS
      end
      local x, y, _,_ = segments[1]:unpack()
      for i = 1, GAP_SEGMENTS do
        local a do 
          if inverse then
            a = -angles[i]
          else
            a = angles[i]
          end
        end
        local targetX = -(SEGMENT_LENGTH * math.cos(a)) + x
        local targetY = (SEGMENT_LENGTH * math.sin(a)) + y
        table.insert(segments, 1, geo.lineSegment.new(targetX, targetY, x, y))
        x = targetX
        y = targetY
      end
    end

    -- for i=1, #segments do
    --   print(segments[i].x)
    -- end
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