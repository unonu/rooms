require('states')
require('functions')
require('tween')
require('gui')
require('rooms')
require('res')
require('camera')
require('run')
require('player')

-- http://www.amazon.com/gp/student/signup/info?ie=UTF8&refcust=XA44UITVS3IIAIENDC6B7CPXVI&ref_type=generic

function love.load()
	print('Loading...')
	local stime = love.timer.getTime()
	-----------------------------------------------------------------------------------
	
	print('welcome to ROOMS\nbe careful out there\n')
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	clearScreen = 1
	
	fonts = loadFonts()
	tweens = {}
	indexRes()
	
	love.graphics.setFont(fonts.large)
	
	state = states.startScreen.make()
	
	-----------------------------------------------------------------------------------
	print('Done Loading. Took '..(love.timer.getTime()-stime)..' seconds to load.\n')
	-- FPS cap
	min_dt = 1/48
	next_time = love.timer.getMicroTime()
	
end

function love.draw()
	love.graphics.setColor(255,255,255)
	state:draw()
	love.graphics.setColor(25,255,255,12)
	love.graphics.line(0,getCentreScreen('y'),width,getCentreScreen('y'))
	love.graphics.line(getCentreScreen('x'),0,getCentreScreen('x'),height)
	love.graphics.setFont(fonts.small)
		love.graphics.setColor(0,0,0,24)
	love.graphics.rectangle('fill',0,0,width,16)
		love.graphics.setColor(255,255,255)
	love.graphics.print('ROOMS - ALPHA 00',0,4)
	local fps = love.timer.getFPS()
	love.graphics.print(fps..' fps',width-fonts.small:getWidth(fps..' fps'),4)
	if clearScreen < 1 then
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle('fill',width-fonts.small:getWidth(fps..' fps')-20,4,8,8)
	end
	
	-- FPS cap
	local cur_time = love.timer.getMicroTime()
	if next_time <= cur_time then
		next_time = cur_time
	return
	end
	love.timer.sleep((next_time - cur_time))
end

function love.update(dt)
	state:update(dt)
	for i,t in pairs(tweens) do
		t:update()
--		if t.done then
--			table.remove(tweens, t)
--		end
	end
	
	--  FPS cap
	next_time = next_time + min_dt
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	elseif k == '\\' then
		clearScreen = -clearScreen
	end
	state:keypressed(k)
end

function love.mousepressed(x,y,button)
	state:mousepressed(x,y,button)
end
