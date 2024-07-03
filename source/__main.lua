import 'CoreLibs/ui/gridview.lua'
import 'CoreLibs/graphics' -- kTextAlignment

local displayWidth = playdate.display.getSize()
local centerX = displayWidth/2

local gfx = playdate.graphics
gfx.clear()

local listFont = gfx.font.new('font/Bitmore-Medieval')
listFont:setTracking(1)	

local menuOptions = {"Start game", "Options", "Scoreboard", "Credits"}

local size = playdate.geometry.point.new(100, 85)
local bg = gfx.image.new(size.x, size.y)
local margin = 4
gfx.pushContext(bg)
	gfx.fillRect(0, 0, size.x, size.y)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(margin, margin, size.x-(margin*2), size.y-(margin*2))
gfx.popContext()
margin = margin*10
local r = playdate.geometry.rect.new(displayWidth/2-size.x/2, 60, size.x, size.y)

local listview = playdate.ui.gridview.new(0, 10)
listview.backgroundImage = bg
listview:setNumberOfRows(#menuOptions)
listview:setCellPadding(0, 0, 0, 10)
listview:setContentInset(10, 10, 13, 11)

function listview:drawCell(section, row, column, selected, x, y, width, height)
	if selected then
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRoundRect(x, y, width, 20, 4)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
	gfx.setFont(listFont)
	gfx.drawTextInRect(menuOptions[row], x, y+6, width, height+2, nil, "...", kTextAlignment.center)
end

function playdate.AButtonUp()
	local _, row = listview:getSelection() 
	print(row, menuOptions[row])
end

function playdate.BButtonUp()
	local _, row = listview:getSelection() 
	print(row, menuOptions[row])
end

function playdate.upButtonUp()
	listview:selectPreviousRow(false)
end

function playdate.downButtonUp()
	listview:selectNextRow(false)
end

function playdate.update()
	playdate.timer.updateTimers()
	if listview.needsDisplay == true then
		local x, y, w, h = r:unpack()
		gfx.setColor(gfx.kColorWhite)
		-- gfx.fillRect(x, y, w, h)
		listview:drawInRect(x, y, w, h)
	end	
end
