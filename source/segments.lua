local geo <const> = playdate.geometry
local _, displayHeight <const> = playdate.display.getSize()

local MAX_SEGMENTS <const> = 5
local SEGMENT_LENGTH <const> = 250

function createFirstSegments()
  local segments = {}
  local offset = 0
  local lineStart
  local h = displayHeight-50
  for i = 1, MAX_SEGMENTS do
    lineStart = offset*SEGMENT_LENGTH
    local ls = geo.lineSegment.new(lineStart, h, lineStart+SEGMENT_LENGTH, h)
    offset += 1
    table.insert(segments, ls)
  end
  return segments
end