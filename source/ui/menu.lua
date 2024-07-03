import 'CoreLibs/graphics'

import 'fontcache'
import 'textfield'

local displayWidth, displayHeight = playdate.display.getSize()
local centerX = displayWidth/2

local gfx = playdate.graphics

local menuOptions = {"START GAME", "OPTIONS"}
local selection = 1

local top = displayHeight/2-60
local img = gfx.image.new(100, 22)
gfx.pushContext(img)
	gfx.fillRoundRect(0, 0, 100, 22, 4)
gfx.popContext()
local selected = gfx.sprite.new(img)
selected:moveTo(centerX, top+selection*30)
selected:add()
local textFields = {}
for i = 1, #menuOptions do
	local tf = Textfield:new(centerX, top+i*30, menuOptions[i])
	tf:setFont(getFont('menu'))
	if i == selection then 
		tf:setDrawMode(gfx.kDrawModeFillWhite)
	else
		tf:setDrawMode(gfx.kDrawModeCopy)
	end
	tf:add()
	table.insert(textFields, tf)
end

function drawMenu()
	selected:moveTo(centerX, top+selection*30)
	for i = 1, #textFields do
		local tf = textFields[i]
		if i == selection then 
			tf:setDrawMode(gfx.kDrawModeFillWhite)
		else
			tf:setDrawMode(gfx.kDrawModeCopy)
		end
	end
end

function playdate.upButtonUp()
	selection -= 1
	if selection == 0 then 
		selection = #menuOptions
	end
	drawMenu()
end

function playdate.downButtonUp()
	selection += 1
	if selection > #menuOptions then 
		selection = 1
	end
	drawMenu()
end

function playdate.update()
  playdate.graphics.sprite.update()
end
