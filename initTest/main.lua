require('rooms')
require('tiles')
require('camera')

function love.load()
--	a = room.make(1,1,1,4,4,{1,1,2,2},{1,1,2,2,3,3},{4,4,3})
	rooms = loadMap('test_02')
	roomToDraw = 1
end

function love.draw()
--	for yy = 0, 100 do
--		for xx = 100, 0, -1 do
			for y,t in pairs(rooms) do
--				if t.y + t.height == yy then
--					if t.x + t.width == xx then
						t:draw()					
--					end
--				end
			end
--	xx = xx + 1
--		end
--	yy = yy + 1
--	end
--	rooms[roomToDraw]:draw()
end

function love.update(dt)
	love.graphics.setCaption(love.timer.getFPS())
	
	mousex, mousey = love.mouse.getPosition()
	
	if mousex < 48 then
		camera:move(-2)
	elseif mousex > love.graphics.getWidth()-48 then
		camera:move(2)
	end
	
	if mousey < 48 then
		camera:move(0,-2)
	elseif mousey > love.graphics.getHeight()-48 then
		camera:move(0,2)
	end
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	elseif k == '1' then
		roomToDraw = 1
	elseif k == '2' then
		roomToDraw = 2
	elseif k == '3' then
		roomToDraw = 3
	elseif k == '4' then
		roomToDraw = 4
	elseif k == '5' then
		roomToDraw = 5
	elseif k == '6' then
		roomToDraw = 6
	end
end
