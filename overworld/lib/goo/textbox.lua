textbox = {}
textbox.__index = textbox
function textbox.make(name,default,length,space)
	local t = {}
	setmetatable(t,textbox)
	t.name = name or 'textbox'..tostring(t)
	t.default = default or ''
	t.length = lenth or -1
	t.buffer = nil
	t.state = 'unfocused'
	t.fg = {0,0,0,255}
	t.bg = {255,255,255,255}
	t.w = math.max(150,love.graphics.getFont():getWidth(t.default))
	t.h = love.graphics.getFont():getHeight('^j')
	t.x = 0
	t.y = 0
	t.carret = 0 --after the 1st item
	-- add font stuff --
	--
	-- parenting stuff. I'll work it out later --
	t.spacing = space or 'stretch'
	t.parent = nil
	--
	return t
end

function textbox:draw()
	love.graphics.setColor(unpack(self.bg))
	love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
	love.graphics.setColor(unpack(self.fg))
	local textX = math.min(0,self.w-love.graphics.getFont():getWidth(self.buffer or self.default))
	local carretX = textX+love.graphics.getFont():getWidth(string.sub(self.buffer or "",1,self.carret))
	-- textX = math.min(self.w-carretX,textX)
	-- textX = textX + (love.graphics.getFont():getWidth(self.buffer or self.default)+carretX)--math.min(0,-self.w-carretX)
	-- textX = math.min(math.max(textX,textX-carretX+1),textX+carretX+1)
	textX = textX-(math.min(0,carretX))
	print(math.min(0,carretX),textX-carretX)
		love.graphics.setScissor(self.x,self.y,self.w,self.h)
		if self.buffer then love.graphics.setColor(0,0,0) else love.graphics.setColor(128,128,128) end
	love.graphics.print(self.buffer or self.default,self.x+textX,self.y)
		love.graphics.setScissor()
	love.graphics.rectangle('line',self.x,self.y,self.w,self.h)
	if self.state == 'focused' then
		love.graphics.setColor(255,0,0)
		if self.buffer then
			love.graphics.line(carretX,self.y+2,carretX,self.y+self.h-2)
		else love.graphics.line(self.x,self.y+2,self.x,self.y+self.h-2) end
	end

end

function textbox:keypressed(k)
	if k == 'backspace' then
		print(self.carret)
		if self.carret > 0 then
			self.carret = self.carret - 1
			self.buffer = string.sub(self.buffer,1,self.carret)..string.sub(self.buffer,self.carret+2)
		end
	elseif k == 'delete' then
		if self.carret < string.len(self.buffer) then
			self.buffer = string.sub(self.buffer,1,self.carret)..string.sub(self.buffer,self.carret+2)
		end
	elseif k == 'left' then
		if self.carret > 0 then self.carret = self.carret - 1 end
	elseif k == 'right' then
		if self.carret < string.len(self.buffer) then self.carret = self.carret + 1 end
	elseif k == 'v' and love.keyboard.isDown('lctrl','rctrl') then
		self.buffer = string.sub(self.buffer,1,self.carret)..love.system.getClipboardText()..string.sub(self.buffer,self.carret+1)
		self.carret = self.carret + string.len(love.system.getClipboardText())
		print("Pasted "..love.system.getClipboardText().."from clipboard")
	elseif k == 'c' and love.keyboard.isDown('lctrl','rctrl') then
		love.system.setClipboardText(self.buffer)
		print("Copied "..self.buffer.."to clipboard")
	end
end

function textbox:textinput(t)
if self.state == 'focused' then
	if self.buffer then
		self.buffer = string.sub(self.buffer,1,self.carret)..t..string.sub(self.buffer,self.carret+1)
		self.carret = self.carret + 1
		print(self.carret)
	else
		self.buffer = t
		self.carret = self.carret + 1
	end
end end

function textbox:mousepressed(x,y,button)
	if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
		if button == 'l' then
			self.state = 'focused'
			-- self.carret = math.min(math.floor((x-self.x)/love.graphics.getFont():getHeight('a')),string.len(self.buffer or 'a'))
		elseif button == 'm' then
			self.state = 'focused'
			self.buffer = string.sub(self.buffer,1,self.carret)..love.system.getClipboardText()..string.sub(self.buffer,self.carret)
			self.carret = self.carret + string.len(love.system.getClipboardText())
			print("Pasted "..love.system.getClipboardText().."from clipboard")
		end
	else
		self.state = 'unfocused'
		if self.buffer == '' then self.buffer = nil end
	end
end