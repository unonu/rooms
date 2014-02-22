gui = {}

gui.openSave = {}
gui.openSave.__index = gui.openSave

function gui.openSave.make(name, x, y, width, height, colour)
	local w = {}
	setmetatable(w, gui.openSave)
	
	w.name = name
	w.x = x
	w.y = y
	w.absx = x
	w.absy = y
	w.width = width
	w.height = height
	w.focused = false
	w.colour = colour or {red = 255, green = 255, blue = 255}
	w.alpha = 221
	w.localTweens = {up = tween.make(0,24),down = tween.make(24,0,-1)}
	
	return w
end

function gui.openSave:draw()
		love.graphics.setColor(0,0,0,16)
	love.graphics.rectangle('fill',self.x+4,self.y+4,self.width,self.height)
	--
		love.graphics.setColor(self.colour.red,self.colour.green,self.colour.blue,self.alpha)
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
		local x, y = love.mouse.getPosition()
	if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height then
		love.graphics.print(self.name,self.x,self.y - 18)
	end
		love.graphics.setColor(0,0,0,24)
		love.graphics.setLineWidth(2)
	love.graphics.rectangle('line',self.x,self.y,self.width,self.height)
end

function gui.openSave:update()
		local x, y = love.mouse.getPosition()
	if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height then
		if self.localTweens.down.val < self.localTweens.up.val then
			self.localTweens.up.val = self.localTweens.down.val
		end
		self.localTweens.up:update()
		self.y = self.absy - self.localTweens.up.val
		self.alpha = 221+self.localTweens.up.val
--		print(self.absy + self.localTweens.up.val)
		self.localTweens.down:reset()
	else
--		self.localTweens.up.play = false
		if not self.focused then
		if self.localTweens.down.val < self.localTweens.up.val then
			self.localTweens.down.val = self.localTweens.up.val
		end
		
		self.localTweens.down:update()
		self.y = self.absy - self.localTweens.down.val
		self.alpha = 221+self.localTweens.down.val
		self.localTweens.up:reset()
--		print('arggg')
		end
	end
end

function gui.openSave:mousepressed(x,y,button)
	if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height and button == 'l' then
		self.focused = true
	else
		self.focused = false
	end
end
