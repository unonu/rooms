--[[===========<+>===========]]--
--      OREA Game Studios      --
--          (c) 2014           --
--                             --
--    The Gap Between Worlds   --
--      Action Adventure       --
--                             --
--  Don't You Dare Coppy This  --
--                             --
--[[===========<+>===========]]--


for i,l in ipairs(love.filesystem.getDirectoryItems('lib')) do
	if string.sub(l,-4) == '.lua' then
		print('Requiring '..string.sub(l,1,-5))
		require('lib/'..string.sub(l,1,-5))
	end
end
for i,l in ipairs(love.filesystem.getDirectoryItems('')) do
	if string.sub(l,1,-5) ~= 'main' and string.sub(l,-4) == '.lua' then
		print('Requiring '..string.sub(l,1,-5))
		require(string.sub(l,1,-5))
	end
end

function love.load()
	orea.initFS('tgbOREA')
	res.init()
	screen.init(1280,720)
	fonts = loadFonts()
	love.mouse.setVisible(false)
	--
	state = states.game.make()
	prevState = nil
end

function  love.draw()
	-- screen:setChromaticFilter()
	screen:draw()
	if state.draw then state:draw() end
	screen:drawFade()
	-- screen:releaseChromaticFilter()
end


function  love.update(dt)
	if prevState ~= state.name then prevState = state.name; print(state.name) end
	if state.update then state:update(dt) end
	screen:update(dt)
end

function  love.keypressed(k)
	if k == 'escape' then love.event.quit() end
	if state.keypressed then state:keypressed(k) end
end

function  love.mousepressed(x,y,button)
	if state.mousepressed then state:mousepressed(x,y,button) end
end

function love.mousereleased(x,y,button)
	if state.mousereleased then state:mousereleased(x,y,button) end
end