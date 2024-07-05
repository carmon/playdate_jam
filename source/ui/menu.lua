import 'textfield'

local gfx = playdate.graphics

Menu = {}
Menu.__index = Menu

function Menu:new(x, y, options, selection)
	local self = {}

	local offset = 30 -- due to 1-indexed arrays, first element already has offset applied
	local buttonBg = nil
	local textFields = {}

	function self:add()
		if buttonBg == nil then
			local img = gfx.image.new(100, 22)
			gfx.pushContext(img)
				setColor('dark')
				gfx.fillRoundRect(0, 0, 100, 22, 4)
				setColor('light')
				gfx.fillRoundRect(2, 2, 100-4, 22-4, 4)
			gfx.popContext()
			buttonBg = gfx.sprite.new(img)
			buttonBg:moveTo(x, y+selection*offset)
		end
		buttonBg:add()
		if #textFields == 0 then
			for i = 1, #options do
				local tf = Textfield:new(x, y+i*offset, options[i])
				if i == selection then 
					-- tf:setDrawMode(gfx.kDrawModeFillWhite)
				else
					-- tf:setDrawMode(gfx.kDrawModeCopy)
				end
				table.insert(textFields, tf)
			end
		end
		for i = 1, #textFields do
			textFields[i]:add()
		end
	end

	function self:remove()
		buttonBg:remove()
		for i = 1, #textFields do
			textFields[i]:remove()
		end
	end

	function draw()
		buttonBg:moveTo(x, y+selection*offset)
		for i = 1, #textFields do
			local tf = textFields[i]
			if i == selection then 
				-- tf:setDrawMode(gfx.kDrawModeCopy)
			else
				-- tf:setDrawMode(gfx.kDrawModeCopy)
			end
		end
	end

	function self:setSelection(value)
		selection = value
		draw()
	end

	return self
end