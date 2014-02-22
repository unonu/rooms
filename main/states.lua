states = {}

states.startScreen = {}
states.startScreen.__index = states.startScreen

function states.startScreen.make()
	local s = {}
	setmetatable(s,states.startScreen)
	
	love.graphics.setBackgroundColor(64,64,64)
	
	tweens.menuFadeIn = tween.make(255,0,-2)
	s.res = {}
	s.res.bg = loadRes('image','titleBack.png')
	s.res.mg = loadRes('image','titleMid.png')
	s.res.fg = loadRes('image','titleFront.png')

	return s
end

function states.startScreen:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.res.bg, -320-((love.mouse.getX()-640)/18),-180-((love.mouse.getY()-360)/18))
	love.graphics.draw(self.res.mg, -320-((love.mouse.getX()-640)/22),-180-((love.mouse.getY()-360)/22))
	love.graphics.draw(self.res.fg, -320+((love.mouse.getX()-640)/18),-180+((love.mouse.getY()-360)/18))
			love.graphics.setFont(fonts.large)
			love.graphics.setColor(128,128,128)
	love.graphics.print('ROOMS',getCentreScreen('x')-((getCentreScreen('x')-love.mouse.getX())/12)-(fonts['large']:getWidth('ROOMS')/2),getCentreScreen('y')-((getCentreScreen('y')-love.mouse.getY())/12)-(fonts['large']:getHeight('ROOMS')/2))
			love.graphics.setFont(fonts.small)
			love.graphics.setColor(255,255,255)
	love.graphics.print('press [space]',getCentreScreen('x')-((getCentreScreen('x')-love.mouse.getX())/8)-(fonts['small']:getWidth('press [space]')/2),getCentreScreen('y')-((getCentreScreen('y')-love.mouse.getY())/8)-(fonts['small']:getHeight('press [space]')/2))
			love.graphics.setColor(0,0,0,tweens.menuFadeIn.val)
	love.graphics.rectangle('fill',0,0,width,height)
end

function states.startScreen:update(dt)

end

function states.startScreen:keypressed(k)
	if k == ' ' then
		state = states.game.make()
	end
end

function states.startScreen:mousepressed(x,y,button)

end

-------------------------------------------------------------------------------------------------------------------------
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
-------------------------------------------------------------------------------------------------------------------------

states.menu = {}
states.menu.__index = states.menu

function states.menu.make()
	local m = {}
	setmetatable(m,states.menu)
	
	m.res = {}
	m.res.bg = loadRes('image','titleBack.png')
	
	m.windows = {gui.openSave.make('slot 1',128,getCentreScreen('y')-128,256,256),gui.openSave.make('slot 2',512,getCentreScreen('y')-128,256,256),gui.openSave.make('slot 3',896,getCentreScreen('y')-128,256,256),}
	
	tweens.menuFadeIn:reset()
	
	return m
end

function states.menu:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.res.bg, -320-((love.mouse.getX()-640)/22),-180-((love.mouse.getY()-360)/22))

	for i,w in ipairs(self.windows) do
		w:draw()
	end
		love.graphics.setFont(fonts.large)
		love.graphics.setColor(255,255,255)
	love.graphics.print('Choose a Profile',getCentreScreen('x')-((getCentreScreen('x')-love.mouse.getX())/12)-(fonts['large']:getWidth('Choose a Profile')/2),96-((getCentreScreen('y')-love.mouse.getY())/12)-(fonts['large']:getHeight('Choose a Profile')/2) )

		love.graphics.setColor(255,255,255,tweens.menuFadeIn.val)
	love.graphics.rectangle('fill',0,0,width,height)
end

function states.menu:update(dt)
	for i,w in ipairs(self.windows) do
		w:update()
	end
end

function states.menu:keypressed(k)

end

function states.menu:mousepressed(x,y,button)
	for i,w in ipairs(self.windows) do
		w:mousepressed(x,y,button)
	end
end


-------------------------------------------------------------------------------------------------------------------------
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
-------------------------------------------------------------------------------------------------------------------------

states.game = {}
states.game.__index = states.game

function states.game.make()
	local g = {}
	setmetatable(g,states.game)
	tweens.hudDisplace = tween.make(1,0,-0.2)
	g.canvases = { corrector = love.graphics.newCanvas()}
	g.res = {}
	g.res.critArea = loadRes('image','critArea.png')
	g.res.torchlight = loadRes('image','torchlight.png')
	g.player = initPlayer()
	g.dungeon = dungeon.make('trainingGround')
	g.time = 0
	g.numChunks = 0
	g.bodies = { dynamic = {players = {}, mobs = {}}, static = {drops = {}, structure = {}}}
	-- camera:scale(4)
	-- g.rooms ={}
	-- for i= 1, 1 do
	-- 	g.rooms[i] = room.make(0,0,{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1.5,1.5,1,1,1,1,1,1,1.5,1.5,1,1,1,1,1.5,1.5,1.5,1.5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1})
	-- end
	
	
	return g
end

function states.game:draw()
	camera:set()
			-- self.dungeon.rooms[2]:draw(100,100)

		-- for i, r in ipairs(self.dungeon.rooms) do
		-- 	r:draw(r.x+i*100,r.y+i*20)
		-- end

		for i = 0, self.dungeon.height-1 do
		for ii = 0, self.dungeon.width-1 do
			local index = (ii+(i*(self.dungeon.width)) +1)
			-- print(index)
			local x = (ii*384)-(i*384)
			local y = (ii*128)+(i*128)
			if x+748 > camera._x and x-48 < camera._x + width and y+200 > camera._y-256 and y-200 < camera._y + height then
				self.dungeon.rooms[index]:draw(x,y)
				self.numChunks = self.numChunks+1
			end
		end
		end

--		love.graphics.draw(self.res.player,getCentreScreen('x'),getCentreScreen('y'))
		self.player:draw()
		-- love.graphics.setColor(255,0,0,100)
		-- love.graphics.polygon('fill',camera._x,camera._y,camera._x+width,camera._y,camera._x+width,camera._y+height,camera._x,camera._y+height,camera._x,camera._y)
	camera:unset()
	--------------Colour correct--------------------------------------------------------------
	love.graphics.setCanvas(self.canvases.corrector)
	if self.time < 69120/2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill',0,0,width,height)
	else
		love.graphics.setColor(50,50,100)
		love.graphics.rectangle('fill',0,0,width,height)
		love.graphics.setColor(255,math.random(245,255),math.random(200,212))
		-- love.graphics.circle('fill',getCentreScreen('x'),getCentreScreen('y'),200,36)
		love.graphics.draw(self.res.torchlight,getCentreScreen('x')-256,getCentreScreen('y')-84,0,2)
	end
	

	love.graphics.setCanvas()
	love.graphics.setBlendMode('multiplicative')
		love.graphics.draw(self.canvases.corrector,0,0)
	love.graphics.setBlendMode('alpha')
	----------------------------------------------------------------------------------------

	--------------HUD-----------------------------------------------------------------------------
	love.graphics.setColor(255,255,255)
	
	local hudDisplace = tweens.hudDisplace.val
	
	love.graphics.draw(self.res.critArea,0,0)
	
	love.graphics.rectangle('fill',14,height-128+(128*hudDisplace),196,128)
	love.graphics.rectangle('fill',212,height-70+(140*hudDisplace),198,24)
	love.graphics.rectangle('fill',212,height-40+(64*hudDisplace),198,24)
	
	love.graphics.rectangle('fill',getCentreScreen('x')-164,height-48+(48*hudDisplace),48,48)
	love.graphics.rectangle('fill',getCentreScreen('x')-108,height-48+(48*hudDisplace),48,48)
	love.graphics.rectangle('fill',getCentreScreen('x')-52,height-48+(48*hudDisplace),48,48)
	love.graphics.rectangle('fill',getCentreScreen('x')+4,height-48+(48*hudDisplace),48,48)
	love.graphics.rectangle('fill',getCentreScreen('x')+60,height-48+(48*hudDisplace),48,48)
	love.graphics.rectangle('fill',getCentreScreen('x')+116,height-48+(48*hudDisplace),48,48)
	
	love.graphics.rectangle('fill',width-142,height-128+(128*hudDisplace),128,128)
	love.graphics.rectangle('fill',width-192,height-94+(142*hudDisplace),48,48)
	love.graphics.rectangle('fill',width-300,height-40+(64*hudDisplace),156,24)
	
	love.graphics.polygon('fill',width-300,0,width-300,18,width-276,26,width-252,18,width-252,0)
	----------------------------------------------------------------------------------------------

	------------Debug--------------------------------------------------------------------------
	local debugText = 'camera: '..camera._x..', '..camera._y..'\ndungeon: '..self.dungeon.name..'\nrooms: '..#self.dungeon.rooms..'\ntime: '..self.time..'\nchunks: '..self.numChunks
	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle('fill',0,0,100,100)
	love.graphics.setColor(255,255,255)
	love.graphics.print(debugText,16,16)
end

function states.game:update(dt)
	-- for i, b in pairs(self.bodies) do
		for di, d in ipairs(self.bodies.dynamic) do
			
		end
		for si, s in ipairs(self.bodies.static) do

		end
	-- end

	---------------------------------------------------------
	self.numChunks = 0
	if love.keyboard.isDown('up') then
		camera:move(0,-8)
		self.player:move(0,-8)
	end
	if love.keyboard.isDown('down') then
		camera:move(0,8)
		self.player:move(0,8)
	end
	if love.keyboard.isDown('left') then
		camera:move(-8)
		self.player:move(-8)
	end
	if love.keyboard.isDown('right') then
		camera:move(8)
		self.player:move(8)
	end

	--------Time------------------------------------------------------------------------
	if self.time < 69120 then
		self.time = self.time + 1
	else
		self.time = 0
	end
end

function states.game:keypressed(k)
	if k == 'n' then
		self.time = 34560
	elseif k == 'd' then
		self.time = 0
	end
end

function states.game:mousepressed(x,y,button)
	
end
