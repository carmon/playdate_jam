import 'textfield'

local gfx = playdate.graphics

Menu = {}
Menu.__index = Menu

function Menu:new(x, y, options, selection)
	local self = {}

	local offset = 30 -- due to 1-indexed arrays, first element already has offset applied
	local buttonBg = nil
	local textFields = {}
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

	function self:add()
		if buttonBg == nil then
			local img = gfx.image.new(160, 22)
			buttonBg = gfx.sprite.new(img)
			buttonBg:moveTo(x, y+selection*offset)
		end
		self:draw()
		buttonBg:add()
		
		for i = 1, #textFields do
			textFields[i]:add()
		end
	end
	
	function self:setValue(it, value)
		if textFields[it] ~= nil then
			textFields[it]:setValue(value)
		end
	end

	function self:remove()
		buttonBg:remove()
		for i = 1, #textFields do
			textFields[i]:remove()
		end
	end

	function self:draw()
		local img = buttonBg:getImage()
    local w, h = buttonBg:getSize()
		gfx.pushContext(img)
			setColor('dark')
			gfx.fillRoundRect(0, 0, w, h, 4)
			setColor('light')
			gfx.fillRoundRect(2, 2, w-4, h-4, 4)
		gfx.popContext()
		-- for i = 1, #textFields do
		-- 	local tf = textFields[i]
		-- 	if i == selection then 
		-- 		-- tf:setDrawMode(gfx.kDrawModeCopy)
		-- 	else
		-- 		-- tf:setDrawMode(gfx.kDrawModeCopy)
		-- 	end
		-- end
	end

	function self:setSelection(value)
		selection = value
		buttonBg:moveTo(x, y+selection*offset)
	end

	return self
end