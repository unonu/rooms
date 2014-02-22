screen = {}
screen.__index = screen
function screen.init(w,h)
	local s = {}
	setmetatable(s,screen)
	s.width = w or 1280
	s.height = h or 720
	love.window.setMode(s.width,s.height)
	-- s.images = {}
	-- 	s.images.flash = res.load("image","flash.png")
	-- 	s.images.background = res.load("image","background.png")
	s.timers = {}
		s.timers.shake = 0
		s.timers.chrome = 0
		s.timers.flashPeriod = {0,0}
		s.timers.flashDuration = 0
		s.timers.fade = {}
	s.colors = {}
		s.colors.flash = {255,255,255}
	s.canvases = {}
		s.canvases.buffer = love.graphics.newCanvas()
		s.canvases.red = love.graphics.newCanvas()
		s.canvases.green = love.graphics.newCanvas()
		s.canvases.blue = love.graphics.newCanvas()
	s.cameras = {}
	s.camera = nil
	s.delta = nil
	s.flashing = false
	s.modes = love.window.getFullscreenModes()
	s.abberating = false
	s.shaking = false
	s.focus = 0
	s.flashMode = "full"
	s.flashSpeed = 1
	s.background = {0,0,0}
	s.fps = 1/60
	s.fullscreen = false
	table.sort(s.modes, function(a, b) return a.width*a.height < b.width*b.height end)
	s.chromeWhenShake = true
	
	s.next_time = love.timer.getTime()
	screen = s
end

function screen:draw()
	if self.timers.shake ~= 0 then
		self.shakeing = true
		self.timers.shake = self.timers.shake - 1
		self.timers.shake = math.max(self.timers.shake,-1)
		love.graphics.translate(math.random(-self.delta,self.delta),math.random(-self.delta,self.delta))
		if self.chromeWhenShake then
			self.timers.chrome = self.timers.shake
		end
	else self.shaking = false
	end
	
	if self.timers.chrome ~= 0 then
		if self.chromeWhenShake and self.timers.shake > 0 then
			self.focus = math.random(-self.delta,self.delta)
		else
			self.timers.chrome = self.timers.chrome - 1
			self.timer = math.max(self.timers.shake,-1)
		end
	else
		self.focus = 0
	end
end

function screen:drawFlash()
	if self.timers.flashDuration ~= 0 then
		self.flashing = true
		if self.flashMode == "full" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*255,0))
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		elseif self.flashMode == "edge" then
			love.graphics.setColor(self.colors.flash[1],self.colors.flash[2],self.colors.flash[3],math.max(self.timers.flashPeriod[1]/self.timers.flashPeriod[2]*255,0))
			love.graphics.draw(self.images.flash,0,0,0,self.width/256,self.height/256)
		else
			print("[WARNING]: (Screen) Unsupported flash mode. Doing nothing.")
		end
		if self.timers.flashPeriod[1] > 0 then
			self.timers.flashPeriod[1] = self.timers.flashPeriod[1] - (.1*self.flashSpeed)
		else
			self.timers.flashPeriod[1] = self.timers.flashPeriod[2]
			self.timers.flashDuration = self.timers.flashDuration - 1
		end
	else
		self.flashing = false
	end
end

function screen:update()
	self.next_time = self.next_time + self.fps
	if love.graphics.getWidth() ~= screen.width then love.graphics.setMode(screen.width,screen.height) end
	if love.graphics.getHeight() ~= screen.height then love.graphics.setMode(screen.width,screen.height) end
	if self.timers.chrome == 0 then self.abberating = false else self.abberating = true end
	-- if #self.cameras > 0 then
	-- 	for i,c in ipairs(self.cameras) do

	-- 	end
	-- end
end

function screen:shake(time,delta,chrome,deteriorate)
	if chrome == false then
		self.chromeWhenShake = false
	else
		self.chromeWhenShake = true
	end
	self.timers.shake = (time or 1)*60
	self.delta = delta or 4
	self.delta = self.delta/2
end

function screen:aberate(time,focus)
	self.timers.chrome = time*60
	self.focus = focus or 1
end

function screen:flash(periods,speed,color,mode)
	if mode then self:setFlashMode(mode) end
	self.timers.flashDuration = periods or 1
	self.timers.flashPeriod = {100,100}
	self.flashSpeed = speed or 1
	self.colors.flash = color or {255,255,255}
end

function screen:setFlashMode(mode)
	self.flashMode = mode
end

function screen:clearEffects()
	self.timers.shake = 0
	self.timers.chrome = 0
	self.timers.flashPeriod = {0,0}
	self.timers.flashDuration = 0
end

function screen:setChromaticFilter()
	love.graphics.setCanvas(self.canvases.buffer)
end

function screen:setBackground(arg)
	self.background = arg
end

function screen:releaseChromaticFilter()
	love.graphics.setCanvas(self.canvases.red)
			love.graphics.push()
			love.graphics.translate(-4*self.focus,0)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
		love.graphics.setColor(255,0,0)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas(self.canvases.green)
			love.graphics.push()
			love.graphics.translate(0,-4*self.focus)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
		love.graphics.setColor(0,255,0)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas(self.canvases.blue)
			love.graphics.push()
			love.graphics.translate(4*self.focus,0)
		if type(self.background) == 'table' then
			love.graphics.setColor(self.background[1],self.background[2],self.background[3])
			love.graphics.rectangle("fill",0,0,self.width,self.height)
		else
			love.graphics.setColor(255,255,255)
			love.graphics.draw(self.background)
		end
		love.graphics.setColor(0,0,255)
		love.graphics.draw(self.canvases.buffer)
			love.graphics.pop()
	love.graphics.setCanvas()
		love.graphics.setColor(255,255,255)
		love.graphics.setBlendMode("additive")
		love.graphics.draw(self.canvases.red)
		love.graphics.draw(self.canvases.green)
		love.graphics.draw(self.canvases.blue)
		love.graphics.setBlendMode("alpha")
	for i,c in pairs(self.canvases) do
		c:clear()
	end
end

function screen:capFPS()
	local cur_time = love.timer.getTime()
	if self.next_time <= cur_time then
		self.next_time = cur_time
		return
	end
	love.timer.sleep((self.next_time - cur_time))
end

function screen:getCentre(xory)
	if xory then
		if xory == 'x' then
			return (self.width/2)
		elseif xory == 'y' then
			return (self.height/2)
		end
	else
		local result = {self.width/2, self.height/2}
		return result
	end
end

screen.toggleFullscreen = love.window.toggleFullscreen

function screen:newCamera(x,y,w,h,s,r)
	local camera = {}
	camera._x = 0
	camera._y = 0
	camera.x = x or 0
	camera.y = y or 0
	camera._width = w or 0
	camera._height = h or 0
	camera.scaleX = s or 1
	camera.scaleY = s or 1
	camera.rotation = r or 0

	function camera:set()
	  love.graphics.push()
	  love.graphics.rotate(-self.rotation)
	  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	  love.graphics.rectangle('line',self.x+1,self.y+1,self._width-2,self._height-2)
	  love.graphics.translate(-self._x+self.x, -self._y+self.y)
	  love.graphics.setScissor(self.x,self.y,self._width,self._height)
	end

	function camera:release()
	  love.graphics.setColor(255,0,0)
	  love.graphics.print(self.x..', '..self.y..'\n'..self._x..', '..self._y,self._x,self._y)
	  love.graphics.setColor(255,255,255)
	  love.graphics.setScissor()
	  love.graphics.pop()
	end

	function camera:move(dx, dy)
	  self._x = self._x + (dx or 0)
	  self._y = self._y + (dy or 0)
	end

	function camera:rotate(dr)
	  self.rotation = self.rotation + dr
	end

	function camera:scale(sx, sy)
		sx = sx or 1
		self.scaleX = sx--self.scaleX * sx
		self.scaleY = sy or sx--self.scaleY * (sy or sx)
		self._w = width*sx
		self._h = height*sx
	end

	function camera:setX(value)
	  if self._bounds then
	    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
	  else
	    self._x = value
	  end
	end

	function camera:setY(value)
	  if self._bounds then
	    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
	  else
	    self._y = value
	  end
	end

	function camera:setPosition(x, y)
	  if x then self:setX(x) end
	  if y then self:setY(y) end
	end

	function camera:setScale(sx, sy)
	  self.scaleX = sx or self.scaleX
	  self.scaleY = sy or self.scaleY
	end

	table.insert(self.cameras,camera)
end