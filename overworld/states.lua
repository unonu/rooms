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
		g.time.day = 0
		g.time.dayLength = 86400--14400
		g.time.step = 1
		g.time.dayIndex = 1
		g.time.times = {'midnight',
						'early',
						'morning',
						'noon',
						'afternoon',
						'evening',
						'night',
						midnight = 0,
						early=g.time.dayLength/6,
						morning=g.time.dayLength/4,
						noon=g.time.dayLength/2,
						afternoon=g.time.dayLength*13/24,
						evening=g.time.dayLength*17/24,
						night=g.time.dayLength*5/6
					}
		g.time.fuzzy = 'midnight'
		g.time.nextFuzzy = 'early'
		g.time.colors = {	midnight = {0,12,48},
							early = {64,50,86},
							morning = {208,220,222},
							noon = {255,255,255},
							afternoon = {255,240,230},
							evening = {150,171,195},
							night = {0,58,142},
						}
		g.time.timeColor = {unpack(g.time.colors[g.time.fuzzy])}
		g.time.colorCorrection = {255,255,255}
		g.time.month = "Clearleaf"
		g.time.months = {	"Clearleaf",
							"B",
							"C",
							"D",
							"E",
							"F",
							"G",
						}
		g.time.monthIndex = 1
		g.time.monthLength = 20
		g.time.year = 0

	g.weather = {}
		g.weather.weather = "clear"
		g.weather.colors = {	"clear",
							"overcast",
							"showers",
							"downpoor",
							"hot",
							"humid",
							"stormy",
							"windy",	
							clear = {255,255,255},
							overcast = {160,160,160},
							showers = {140,140,160},
							downpoor = {128,128,140},
							hot = {255,230,220},
							humid = {250,255,220},
							stormy = {160,170,180},
							windy = {230,230,230},
						}
		g.weather.colorCorrection = {255,255,255}
		--keep these vvv values <= 4 please
		g.weather.rain = 0
		g.weather.wind = 0
		g.weather.cloud = 0
		g.weather.rainTable = {}
		g.weather.windTable = {}
		g.weather.cloudTable = {}

		g.events = loadEvents("res/scripts/game")

		g.textboxes = {}

		g.canvases = {
			lights = love.graphics.newCanvas(screen.width,screen.height),
			colorCorrection = love.graphics.newCanvas(screen.width,screen.height),
		}

	return g
end

function states.game:draw()
	--background
	love.graphics.setBackgroundColor(255,255,255)

	--
	screen.cameras[1]:set()
	----------------------------------------------------------------------------------------------<

	--map
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.map.image)

	--player
	self.p:draw()
	for i,d in ipairs(self.mouse.directions) do
		love.graphics.print(d,self.p.x+48,self.p.y+((i-1)*26))
	end

	--mouse
	love.graphics.setColor(0,128,255,128)
	love.graphics.line(mouseX,screen.cameras[1]._y,mouseX,mouseY)
	love.graphics.circle('fill',mouseX,mouseY,24,4)
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

	----------------------------------------------------------------------------------------------<
	screen.cameras[1]:release()
	--

	--weather
	love.graphics.setColor(255,255,255,128)
	if self.weather.rain > 0 then
		for i,d in ipairs(self.weather.rainTable) do
			d[1] = d[1]+(self.weather.wind*4)
			d[2] = d[2] + 8*d[3]
			love.graphics.line(d[1],d[2],d[1]-(self.weather.wind*4),d[2]-(8*self.weather.rain)-d[3])
			if d[2] > screen.height/(4-d[3]) then table.remove(self.weather.rainTable,i) end
		end
	end

	--colour manipulation
		love.graphics.setCanvas(self.canvases.colorCorrection)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill",0,0,screen.width,screen.height)

		--time
	love.graphics.setColor(unpack(self.time.timeColor))
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)

		--weather
	love.graphics.setBlendMode("multiplicative")
	-- love.graphics.setBlendMode("additive")
	love.graphics.setColor(unpack(self.weather.colorCorrection))
	love.graphics.rectangle("fill",0,0,screen.width,screen.height)
	-- love.graphics.setBlendMode("alpha")

		--lights
	-- 	love.graphics.setColorMask( true,true,true,true )
	-- love.graphics.setBlendMode("replace")
	-- love.graphics.setColor(255,255,255)
	-- love.graphics.draw(self.canvases.lights,0,0)
	-- 	love.graphics.setColorMask()

		love.graphics.setCanvas()

	-- love.graphics.setBlendMode("multiplicative")
	love.graphics.draw(self.canvases.colorCorrection,0,0)
	love.graphics.setBlendMode("alpha")
	--

	love.graphics.print(self.time.time,screen.width-love.graphics.getFont():getWidth(self.time.time),48)
	love.graphics.print('DAY '..self.time.day,0,26)
	love.graphics.print(self.weather.weather:upper()..' '..self.time.fuzzy:upper(),0,52)

	--clock
	love.graphics.setColor(255,255,255)
	love.graphics.circle("fill",screen.width-24,24,24,32)
	love.graphics.setColor(0,0,0)
	love.graphics.arc("fill",screen.width-24,24,25,-(math.pi/2),(math.pi*2)*(self.time.time/self.time.dayLength)-(math.pi/2),32)
end

function states.game:update(dt)
	self:updateTime(dt)
	self:updateWeather(dt)
	cameraX,cameraY = screen.cameras[1]:getPosition()
	cameraWidth,cameraHeight = screen.cameras[1]._width,screen.cameras[1]._height
	mouseX,mouseY = love.mouse.getX()+cameraX,love.mouse.getY()+cameraY

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
		if t.done then
			self.sleep = false
			table.remove(self.textboxes, i)
			print('finished drawing the #'..i..' text box')
		end
	end

	--weather
	--this method for rain is slow and resource intensive. fix it
	if self.weather.rain > 0 then
		if math.floor((.4+(self.weather.rain/10))+math.random(0,100/self.weather.rain)/(100/self.weather.rain)) == 1 then
			for x=1, self.weather.rain^2 do
				local i = math.random(0,screen.width/(128/self.weather.rain))*(128/self.weather.rain)
				table.insert(self.weather.rainTable,{i,0,math.random(1,6)})
			end
		end
	end

	--clear canvases
	for i,c in pairs(self.canvases) do
		c:clear()
	end
	-- love.graphics.setCanvas()
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
	-- player
	self.p:keypressed(k)

	if k == "keytype" then
	-- elseif k == ' ' then
	-- 	table.insert(self.textboxes, textbox.make({'Hello World!', 'In the event of a huricane, I suggest you go and find shelter.'},
	-- 		mouseX,mouseY,true,math.random(1,5)))
	elseif k == 'lshift' then
		table.insert(self.textboxes, textbox.make({'Hello World!', 'In the event of a huricane, I suggest you go and find shelter.',
			'You may now move again.'}, screen.cameras[1]._x,screen.cameras[1]._y,false,2,6,true,true))
	elseif k == '1' then
		self:setTime("midnight")
	elseif k == '2' then
		self:setTime("early")
	elseif k == '3' then
		self:setTime("morning")
	elseif k == '4' then
		self:setTime("noon")
	elseif k == '5' then
		self:setTime("afternoon")
	elseif k == '6' then
		self:setTime("evening")
	elseif k == '7' then
		self:setTime("night")
	elseif k == '`' then
		self:setWeather(self.weather.colors[math.random(1,#self.weather.colors)])
	-- elseif k == 'a' then
	-- 	screen:fade('in',300)
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
		if math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1])
			- math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints]) >= 72 then
			if self.mouse.tempPoints[#self.mouse.tempPoints-3] < self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				self:makeSegment()
			elseif self.mouse.tempPoints[#self.mouse.tempPoints-3] > self.mouse.tempPoints[#self.mouse.tempPoints-1] then
				self:makeSegment()
			end
		elseif math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1])
			- math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints]) <= -72 then
			if self.mouse.tempPoints[#self.mouse.tempPoints-2] < self.mouse.tempPoints[#self.mouse.tempPoints] then
				self:makeSegment()
			elseif self.mouse.tempPoints[#self.mouse.tempPoints-2] > self.mouse.tempPoints[#self.mouse.tempPoints] then
				self:makeSegment()
			end
		elseif math.abs(math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1])
			- math.abs(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints])) < 72
		and ((self.mouse.tempPoints[#self.mouse.tempPoints-3]-self.mouse.tempPoints[#self.mouse.tempPoints-1])^2
			+(self.mouse.tempPoints[#self.mouse.tempPoints-2]-self.mouse.tempPoints[#self.mouse.tempPoints])^2)^.5 >= 86 then
			--
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
		table.insert(self.mouse.segments,
						{self.mouse.tempPoints[1],self.mouse.tempPoints[2],
						self.mouse.tempPoints[#self.mouse.tempPoints-1],self.mouse.tempPoints[#self.mouse.tempPoints]})
	else
		table.insert(self.mouse.segments,
						{self.mouse.segments[#self.mouse.segments][3],self.mouse.segments[#self.mouse.segments][4],
						self.mouse.tempPoints[#self.mouse.tempPoints-1],self.mouse.tempPoints[#self.mouse.tempPoints]})
		--
		if math.abs(((-math.atan2(self.mouse.segments[#self.mouse.segments-1][2]-self.mouse.segments[#self.mouse.segments-1][4],
									self.mouse.segments[#self.mouse.segments-1][1]-self.mouse.segments[#self.mouse.segments-1][3]))+(math.pi))
			- ((-math.atan2(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4],
								self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3]))+(math.pi))) < math.pi/4
		or math.abs(((-math.atan2(self.mouse.segments[#self.mouse.segments-1][2]-self.mouse.segments[#self.mouse.segments-1][4],
									self.mouse.segments[#self.mouse.segments-1][1]-self.mouse.segments[#self.mouse.segments-1][3]))+(math.pi))
			- ((-math.atan2(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4],
								self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3]))+(math.pi))) > 7*math.pi/4 then
			--
			self.mouse.segments[#self.mouse.segments-1][3] = self.mouse.segments[#self.mouse.segments][3]
			self.mouse.segments[#self.mouse.segments-1][4] = self.mouse.segments[#self.mouse.segments][4]
			table.remove(self.mouse.segments,#self.mouse.segments)
		end
	end
	if ((self.mouse.segments[#self.mouse.segments][1]-self.mouse.segments[#self.mouse.segments][3])^2
		+(self.mouse.segments[#self.mouse.segments][2]-self.mouse.segments[#self.mouse.segments][4])^2)^.5 < 96 then
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

function states.game:updateTime(dt)
	--add a day if time == 0
	if self.time.time == 0 then self.time.day = self.time.day + 1; print("Day "..self.time.day) end

	--change the month if day == monthLength
	if self.time.day == self.time.monthLength then self.time.monthIndex = math.loop(1,self.time.monthIndex + 1,#self.time.months) end

	--chang the year if time is 0, month is 1 and day is 1
	if self.time.time == 0 and self.time.day == 1 and self.time.monthIndex == 1 then self.time.year = self.time.year + 1 end

	--update the fuzzy time
	if self.time.time == self.time.times[self.time.nextFuzzy] then
		print("switchFuzzy")
		self.time.dayIndex = math.loop(1, self.time.dayIndex+1, #self.time.times)
		self.time.fuzzy = self.time.times[self.time.dayIndex]
		self.time.nextFuzzy = self.time.times[math.loop(1, self.time.dayIndex+1, #self.time.times)]
	end

	--update colour
	if self.time.time >= math.loop(1,self.time.times[self.time.nextFuzzy],self.time.dayLength) - (self.time.dayLength/24) and
		self.time.time <= math.loop(1,self.time.times[self.time.nextFuzzy],self.time.dayLength) then
		for i = 1, 3 do
			if self.time.timeColor[i] ~= self.time.colors[self.time.nextFuzzy][i] then
				self.time.timeColor[i] = self.time.timeColor[i] + 
					(self.time.colors[self.time.nextFuzzy][i]-self.time.colors[self.time.fuzzy][i])/
					(self.time.dayLength/24)
			end
		end
	else
	--if the time is equal to the next fuzzy time's time, then set the colours equal
		self.time.timeColor[1] = self.time.colors[self.time.fuzzy][1]
		self.time.timeColor[2] = self.time.colors[self.time.fuzzy][2]
		self.time.timeColor[3] = self.time.colors[self.time.fuzzy][3]
	end

	--increment the time by step
	self.time.time = math.loop(0,self.time.time+self.time.step,self.time.dayLength)

end

function states.game:setTime(time)
	if type(time) == "number" then self.time.time = time; print(self.time.time)
	elseif type(time) == "string" then
		self.time.time = self.time.times[time]-1
		self.time.dayIndex = table.getIndex(self.time.times,time)
		self.time.fuzzy = self.time.times[self.time.dayIndex]
		self.time.nextFuzzy = self.time.times[math.loop(1, self.time.dayIndex+1, #self.time.times)]
	end
	print("Changing Time: "..time)
end

function states.game:updateWeather(dt)
	for i = 1, 3 do
		if self.weather.colorCorrection[i] ~= self.weather.colors[self.weather.weather][i] then
			self.weather.colorCorrection[i] = self.weather.colors[self.weather.weather][i] + 
						(self.weather.colors[self.weather.weather][i]-self.weather.colorCorrection[i])/
						(self.time.dayLength/96)
		end
	end

	--rain and wind
	if self.weather.weather == "showers" then
		self.weather.rain = math.random(1,2)
		self.weather.wind = math.floor(0.2+(math.random(0,10)/10))
		self.weather.cloud = math.random(0,2)
	elseif self.weather.weather == "downpoor" then
		self.weather.rain = math.random(3,4)
		self.weather.wind = math.random(1,4)
		self.weather.cloud = math.random(2,4)
	elseif self.weather.weather == "windy" then
		self.weather.rain = 0
		self.weather.wind = math.random(1,4)
		self.weather.cloud = math.random(0,1)
	elseif self.weather.weather == "stormy" then
		self.weather.rain = 0
		self.weather.wind = math.random(2,4)
		self.weather.cloud = math.random(3,4)
	elseif self.weather.weather == "overcast" then
		self.weather.rain = 0
		self.weather.wind = math.floor(0.1+(math.random(0,10)/10))
		self.weather.cloud = math.random(3,4)
	elseif self.weather.weather == "clear" or self.weather.weather == "humid" or self.weather.weather == "hot" then
		self.weather.rain = 0
		self.weather.wind = 0
		self.weather.cloud = 0
	end
end

function states.game:setWeather(weather)
	print("Changing Weather: "..weather)
	self.weather.weather = weather
end