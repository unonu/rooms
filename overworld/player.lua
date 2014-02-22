player = {}
player.__index = player

function player.make(x,y)
	local p = {}
	setmetatable(p,player)
	p.x = x or 0
	p.y = y or 0
	p._x = x
	p._y = y
	p.forces = {} --{direction,magnitude}
	p.timers = {}
		p.timers.waiting = 0
		p.timers.still = 0
	p.speed = 4
	p.walkTargets = {}
	p.walking = false
	p.wait = false

	return p
end

function player:draw()
	if self.timers.waiting == 0 then
		love.graphics.setColor(255,0,0)
	else
		love.graphics.setColor(255,0,0,128)
	end
	love.graphics.rectangle('fill',math.floor(self.x-24),math.floor(self.y-48),48,48)
	love.graphics.setColor(0,255,0,196)
	for i,t in ipairs(self.walkTargets) do
		love.graphics.line(t[1],screen.cameras[1]._y,t[1],t[2])
		-- love.graphics.circle('fill',t[1],t[2],4,3)
	end
end

function player:update( dt )
	if love.keyboard.isDown('w') then
		local projX,projY = math.round(self.x - math.cos(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1),math.round(self.y - math.sin(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1)
		if math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)) > 0 then 
			self.x = projX
		end
		if math.max(unpack({state.map.walkMask:getPixel(self.x,projY)},1,3)) > 0 then 
			self.y = projY
		end
	end
	-- if love.keyboard.isDown('a') then
	-- 	screen.cameras[1]:setPosition(mouseX,mouseY,'c')
	-- 	local projX = math.round(mouseX + math.cos(math.atan2((self.y-mouseY),(self.x-mouseX))+(math.pi/32))*(((self.x-mouseX)^2 + (self.y-mouseY)^2)^.5),1)
	-- 	local projY = math.round(mouseY + math.sin(math.atan2((self.y-mouseY),(self.x-mouseX))+(math.pi/32))*(((self.x-mouseX)^2 + (self.y-mouseY)^2)^.5),1)
	-- 	print(projX,projY)
	-- 	-- local projX,projY = math.round(self.x - math.cos(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1),math.round(self.y - math.sin(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1)
	-- 	if math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)) > 0 then 
	-- 		self.x = projX
	-- 	end
	-- 	if math.max(unpack({state.map.walkMask:getPixel(self.x,projY)},1,3)) > 0 then 
	-- 		self.y = projY
	-- 	end
	-- elseif love.keyboard.isDown('d') then
	-- 	screen.cameras[1]:setPosition(mouseX,mouseY,'c')
	-- 	local projX = math.round(mouseX + math.cos(math.atan2((self.y-mouseY),(self.x-mouseX))-(math.pi/32))*(((self.x-mouseX)^2 + (self.y-mouseY)^2)^.5),1)
	-- 	local projY = math.round(mouseY + math.sin(math.atan2((self.y-mouseY),(self.x-mouseX))-(math.pi/32))*(((self.x-mouseX)^2 + (self.y-mouseY)^2)^.5),1)
	-- 	print(projX,projY)
	-- 	-- local projX,projY = math.round(self.x - math.cos(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1),math.round(self.y - math.sin(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1)
	-- 	if math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)) > 0 then 
	-- 		self.x = projX
	-- 	end
	-- 	if math.max(unpack({state.map.walkMask:getPixel(self.x,projY)},1,3)) > 0 then 
	-- 		self.y = projY
	-- 	end
	-- end
end

function player:mousepressed( x,y,button )
	
end

function player:mousereleased( x,y,button )
	
end

-- function player:update(dt)
-- 	self._x,self._y = self.x,self.y

-- 	if self.timers.still >= 30 then
-- 		self.walkTargets = {}
-- 		self.timers.waiting = self.timers.waiting + .1
-- 	end

-- 	if #self.walkTargets > 0 then
-- 		local projX,projY = math.round(self.x - math.cos(math.atan2((self.y-self.walkTargets[1][2]),(self.x-self.walkTargets[1][1])))*self.speed,1),math.round(self.y - math.sin(math.atan2((self.y-self.walkTargets[1][2]),(self.x-self.walkTargets[1][1])))*self.speed,1)
-- 		if math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)) > 0 then
-- 			-- print(math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)))
-- 			self.x = projX
-- 		end
-- 		if math.max(unpack({state.map.walkMask:getPixel(self.x,projY)},1,3)) > 0 then
-- 			-- print(math.max(state.map.walkMask:getPixel(self.x,projY)))
-- 			self.y = projY
-- 		end
-- 		if self.x >= self.walkTargets[1][1]-self.speed and self.x <= self.walkTargets[1][1]+self.speed and self.y >= self.walkTargets[1][2]-self.speed and self.y <= self.walkTargets[1][2]+self.speed then
-- 			table.remove(self.walkTargets,1)
-- 		end
-- 	elseif love.mouse.isDown('m') then --(((self.x-mouseX)^2)+((self.y-mouseY)^2))^.5 > 128 and
-- 		local projX,projY = math.round(self.x - math.cos(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1),math.round(self.y - math.sin(math.atan2((self.y-mouseY),(self.x-mouseX)))*self.speed,1)
-- 		if math.max(unpack({state.map.walkMask:getPixel(projX+(math.sign(projX-self.x)*24),self.y)},1,3)) > 0 then 
-- 			self.x = projX
-- 		end
-- 		if math.max(unpack({state.map.walkMask:getPixel(self.x,projY)},1,3)) > 0 then 
-- 			self.y = projY
-- 		end
-- 	end

-- 	if self._x == self.x and self._y == self.y and self.speed > 0 then
-- 		self.timers.still = math.min(self.timers.still + .1,30)
-- 	else
-- 		self.timers.still = 0
-- 		self.timers.waiting = 0
-- 	end
-- end

-- function player:mousepressed(x,y,button)
-- 	if button == 'wd' then
-- 		self.speed = math.max(self.speed-1,0)
-- 		print(self.speed)
-- 	elseif button == 'wu' then
-- 		self.speed = math.min(self.speed+1,10)
-- 		print(self.speed)
-- 	end
-- end

-- function player:mousereleased(x,y,button)
-- 	if button == 'm' then
-- 		if x > self.x-24 and x < self.x+24 and y > self.y -48 and y < self.y then
-- 			self.walkTargets = {}
-- 		elseif love.keyboard.isDown('lshift','rshift') then
-- 			table.insert(self.walkTargets,{x,y,2})
-- 		else
-- 			self.walkTargets = {{x,y,2}}
-- 		end
-- 	end
-- end