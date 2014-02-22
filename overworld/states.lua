states = {}

states.game = {}
states.game.__index = states.game

function states.game.make()
	local g = {}
	setmetatable(g,states.game)
	g.name = "game"

	screen:fade('in',60)
	love.graphics.setFont(fonts.boom)
	screen:newCamera(0,0,screen.width,screen.height,1,0,1505,1337)

	g.p = player.make(1476,876)

	g.map = {}
		g.map.image = res.load('image','image.png')
		g.map.walkMask = res.load('mask','mask.png')

	g.mouse = {}
		g.mouse.tempPoints = {0,0}
		g.mouse.dataPoints = {}
		g.mouse.active = false
		g.mouse.step = 0
		g.mouse.directions = {}
		g.mouse.segments = {}

	g.time = {}
		g.time.time = 0
		g.time.today = 0
		g.time.timeStep = 1
		g.time.day = 86400--14400
		g.time.timeFuzzy = 'midnight'
		g.time.nextFuzzy = 'early'
		g.time.weather = 'clear'
		g.time.weathers = {'clear','overcast','showers','downpoor','hot','humid','stormy','windy'}
		g.time.timeNames = {'midnight','early','morning','noon','afternoon','evening','night'}
		g.time.times = {midnight = 0,early=g.time.day/6,morning=g.time.day/4,noon=g.time.day/2,afternoon=g.time.day*13/24,evening=g.time.day*17/24,night=g.time.day*5/6}
		g.time.colorCorrection = {255,255,255}
		g.time.colors = {}
			g.time.colors.midnight = {0,12,48}
			g.time.colors.early = {64,50,86}
			g.time.colors.morning = {208,220,222}
			g.time.colors.noon = {255,255,255}
			g.time.colors.afternoon = {255,240,230}
			g.time.colors.evening = {125,75,90}
			g.time.colors.night = {0,28,112}
			g.time.colors.clear = {}
			g.time.colors.overcast = {}
			g.time.colors.showers = {}
			g.time.colors.downpoor = {}
			g.time.colors.hot = {}
			g.time.colors.humid = {}
			g.time.colors.stormy = {}
			g.time.colors.windy = {}
		g.time.timeColor = {unpack(g.time.colors[g.time.timeFuzzy])}

		g.events = loadEvents("res/scripts/game")

		g.textboxes = {}

	return g
end

function states.game:draw()
	love.graphics.setBackgroundColor(unpack(self.time.timeColor))
	screen.cameras[1]:set()
	--
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.map.image)
	self.p:draw()
	for i,d in ipairs(self.mouse.directions) do
		love.graphics.print(d,self.p.x+48,self.p.y+((i-1)*26))
	end

	love.graphics.setColor(0,128,255,128)
	love.graphics.line(mouseX,screen.cameras[1]._y,mouseX,mouseY)
	love.graphics.circle('fill',mouseX,mouseY,24,4)
	--
	if self.mouse.active then
		love.graphics.setColor(255,0,0)
		love.graphics.setLineWidth(2)
		love.graphics.line(unpack(self.mouse.dataPoints))
	else 
		love.graphics.setColor(255,255,255)
	end
	love.graphics.point(mouseX,mouseY)

	if #self.mouse.tempPoints >= 4 then
		love.graphics.setColor(0,128,255,128)
		love.graphics.setLineWidth(4)
		love.graphics.line(unpack(self.mouse.tempPoints))
	end

	love.graphics.setColor(255,255,0)
	for i,s in ipairs(self.mouse.segments) do
		love.graphics.line(unpack(s))
	end
		love.graphics.setLineWidth(1)

	-- textboxes
	for i,t in ipairs(self.textboxes) do
	t:draw()
	end
	--
	screen.cameras[1]:release()
	--
	love.graphics.print(self.time.time,0,0)
	love.graphics.print('DAY '..self.time.today,0,26)
	love.graphics.print(string.upper(self.time.timeFuzzy),0,52)
end

function states.game:update(dt)
	self:updateTime(dt)
	mouseX,mouseY = love.mouse.getX()+screen.cameras[1]._x,love.mouse.getY()+screen.cameras[1]._y
 if not self.sleep then
	-- player
	self.p:update(dt)
	-- camera
	local cx,cy = screen.cameras[1]._x+(screen.cameras[1]._width/2),screen.cameras[1]._y+(screen.cameras[1]._height/2)
	local cpd = (((cx-self.p.x)^2)+((cy-self.p.y)^2))^.5
	if cpd > 64 then
		screen.cameras[1]:move(-math.round(math.cos(math.atan2((cy-self.p.y),(cx-self.p.x)))*(cpd)/(128/self.p.speed),1))
		screen.cameras[1]:move(0,-math.round(math.sin(math.atan2((cy-self.p.y),(cx-self.p.x)))*(cpd)/(128/self.p.speed),1))
	end
 end
	-- mouse
	self:mousethingUpdate(dt)

	--textboxes
	for i,t in ipairs(self.textboxes) do
		t:update(dt)
		if t.grab then self.sleep = t.grab end
		print(self.sleep)
		if t.done then
			self.sleep = false
			table.remove(self.textboxes, i)
			print('finished drawing the #'..i..' text box')
		end
	end
end

function states.game:mousepressed(x,y,button)
	self.p:mousepressed(mouseX,mouseY,button)
	self.mouse.directions = {}
	if button == 'l' then
		self.mouse.active = true
		self.mouse.tempPoints = {mouseX,mouseY}
		self.mouse.dataPoints = {mouseX,mouseY}
		self.mouse.segments = {}
	end
end

function states.game:mousereleased(x,y,button)
	self.p:mousereleased(mouseX,mouseY,button)
	if button == 'l' then
		self.mouse.active = false
		self:analyse(self.mouse.tempPoints)
		self.mouse.tempPoints = {mouseX,mouseY}
		self.mouse.dataPoints = {mouseX,mouseY}
		self.mouse.segments = {}
	end
end

function states.game:keypressed(k)
	-- if k == 'a' then
	-- 	screen:fade('in',300)
	-- end
	if k == ' ' then
		table.insert(self.textboxes, textbox.make({'Hello World!', 'In the event of a huricane, I suggest you go and find shelter.'},mouseX,mouseY,true,math.random(1,5)))
	elseif k == 'lshift' then
		table.insert(self.textboxes, textbox.make({'Hello World!', 'In the event of a huricane, I suggest you go and find shelter.'},screen.cameras[1]._x,screen.cameras[1]._y,false,2,6,true,true))
	end
end

function states.game:mousethingUpdate(dt)
	if self.mouse.active then
		if self.mouse.step <= 1 then
			table.insert(self.mouse.tempPoints,mouseX)
			table.insert(self.mouse.tempPoints,mouseY)
		end
		table.insert(self.mouse.dataPoints,mouseX)
		table.insert(self.mouse.dataPoints,mouseY)
		self.mouse.step = self.mouse.step + 1
		if self.mouse.step == 4 then self.mouse.step = 0 end
		if math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1]) - math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints]) >= 72 then
			if self.mouse.tempPoints[#self.mouse.tempPoints-3] < self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				self:makeSegment()
			elseif self.mouse.tempPoints[#self.mouse.tempPoints-3] > self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				self:makeSegment()
			end
		elseif math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1]) - math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints]) <= -72 then
			if self.mouse.tempPoints[#self.mouse.tempPoints-2] < self.mouse.tempPoints[#self.mouse.tempPoints] then
				self:makeSegment()
			elseif self.mouse.tempPoints[#self.mouse.tempPoints-2] > self.mouse.tempPoints[#self.mouse.tempPoints] then
				self:makeSegment()
			end
		elseif math.abs(math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1]) - math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints])) < 72
		and ((self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1])^2+(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints])^2)^.5 >= 86 then
			if self.mouse.tempPoints[#self.mouse.tempPoints-3] < self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				if self.mouse.tempPoints[#self.mouse.tempPoints-2] < self.mouse.tempPoints[#self.mouse.tempPoints] then
					self:makeSegment()
				elseif self.mouse.tempPoints[#self.mouse.tempPoints-2] > self.mouse.tempPoints[#self.mouse.tempPoints] then
					self:makeSegment()
				end
			elseif self.mouse.tempPoints[#self.mouse.tempPoints-3] > self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				if self.mouse.tempPoints[#self.mouse.tempPoints-2] < self.mouse.tempPoints[#self.mouse.tempPoints] then
					self:makeSegment()
				elseif self.mouse.tempPoints[#self.mouse.tempPoints-2] > self.mouse.tempPoints[#self.mouse.tempPoints] then
					self:makeSegment()
				end
			end
		end
	else
		self.mouse.dataPoints = {mouseX,mouseY}
		self.mouse.step = 0
	end
	if #self.mouse.tempPoints > 128 then table.remove(self.mouse.tempPoints,1); table.remove(self.mouse.tempPoints,1) end
	if #self.mouse.dataPoints > 128 then table.remove(self.mouse.dataPoints,1); table.remove(self.mouse.dataPoints,1) end
end

function states.game:makeSegment()
	if #self.mouse.segments == 0 then
		table.insert(self.mouse.segments,{self.mouse.tempPoints[1],self.mouse.tempPoints[2],self.mouse.tempPoints[#self.mouse.tempPoints-1],self.mouse.tempPoints[#self.mouse.tempPoints]})
	else
		table.insert(self.mouse.segments,{self.mouse.segments[#self.mouse.segments][3],self.mouse.segments[#self.mouse.segments][4],self.mouse.tempPoints[#self.mouse.tempPoints-1],self.mouse.tempPoints[#self.mouse.tempPoints]})
		if math.abs(((-math.atan2(self.mouse.segments[#self.mouse.segments-1][2]-self.mouse.segments[#self.mouse.segments-1][4],self.mouse.segments[#self.mouse.segments-1][1]-self.mouse.segments[#self.mouse.segments-1][3]))+(math.pi)) - ((-math.atan2(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4],self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3]))+(math.pi))) < math.pi/4
		or math.abs(((-math.atan2(self.mouse.segments[#self.mouse.segments-1][2]-self.mouse.segments[#self.mouse.segments-1][4],self.mouse.segments[#self.mouse.segments-1][1]-self.mouse.segments[#self.mouse.segments-1][3]))+(math.pi)) - ((-math.atan2(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4],self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3]))+(math.pi))) > 7*math.pi/4 then
			self.mouse.segments[#self.mouse.segments-1][3] = self.mouse.segments[#self.mouse.segments][3]
			self.mouse.segments[#self.mouse.segments-1][4] = self.mouse.segments[#self.mouse.segments][4]
			table.remove(self.mouse.segments,#self.mouse.segments)
		end
	end
	if ((self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3])^2+(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4])^2)^.5 < 96 then
		table.remove(self.mouse.segments,#self.mouse.segments)
	end
end

function states.game:analyse(data)
	local intersections = {}
	local circuit = false
	for i,s in ipairs(self.mouse.segments) do
		local r = -math.atan2(s[2]-s[4],s[1]-s[3])+math.pi
		if r < math.pi/8 or r >= 15*math.pi/8 then
			table.insert(self.mouse.directions,'right')
		elseif r >= math.pi/8 and r < 3*math.pi/8 then
			table.insert(self.mouse.directions,'upRight')
		elseif r >= 3*math.pi/8 and r < 5*math.pi/8 then
			table.insert(self.mouse.directions,'up')
		elseif r >= 5*math.pi/8 and r < 7*math.pi/8 then
			table.insert(self.mouse.directions,'upLeft')
		elseif r >= 7*math.pi/8 and r < 9*math.pi/8 then
			table.insert(self.mouse.directions,'left')
		elseif r >= 9*math.pi/8 and r < 11*math.pi/8 then
			table.insert(self.mouse.directions,'downLeft')
		elseif r >= 11*math.pi/8 and r < 13*math.pi/8 then
			table.insert(self.mouse.directions,'down')
		elseif r >= 13*math.pi/8 and r < 15*math.pi/8 then
			table.insert(self.mouse.directions,'downRight')
		end
		for ii =1,math.min(#self.mouse.segments,8) do
			if #intersections < 8 then
			local ss = self.mouse.segments[ii]
			if ii<i-1 or ii>i+1 then
				if math.checkIntersect({s[1],s[2]},{s[3],s[4]},{ss[1],ss[2]},{ss[3],ss[4]}) then
					local pair, clear = {math.min(i,ii),math.max(i,ii)}, true
					for iii,int in ipairs(intersections) do
						if int[1] == pair[1] and int[2] == pair[2] then clear = false end
					end
					if clear then table.insert(intersections,pair) end
				end
			end
			end
		end
	end
	if #intersections >0 then circuit = true end
end

function states.game:updateTime()
	for i,t in pairs(self.time.times) do
		if self.time.time == t then self.time.timeFuzzy = i end
	end
	if self.time.time == 0 then self.time.today = self.time.today + 1 end
	self.time.time = math.loop(0,self.time.time+self.time.timeStep,self.time.day)
	self.time.nextFuzzy = self.time.timeNames[math.loop(1,table.getIndex(self.time.timeNames,self.time.timeFuzzy)+1,7)]
	if self.time.time >= math.loop(1,self.time.times[self.time.nextFuzzy],self.time.day) - (self.time.day/24) then
		for i = 1, 3 do
			if self.time.timeColor[i] ~= self.time.colors[self.time.nextFuzzy][i] then
				self.time.timeColor[i] = self.time.timeColor[i] + (self.time.colors[self.time.nextFuzzy][i]-self.time.colors[self.time.timeFuzzy][i])/(self.time.day/24)
			end
		end
	end
end