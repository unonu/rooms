-- require('lib/jam')
require('lib/orea')
require('lib/screen')
require('lib/res')
require('lib/ansicolours')
require('player')

function love.load()
	meta.name = 'rooms'
	orea.initFS(meta.name)
	res.init()
	fonts = loadFonts()
	screen.init(1280,720)
	love.graphics.setFont(fonts.boom)

	screen:newCamera(0,0,1280,720)
	walkMask = res.load('image','testMask.png')
	walkMaskData = love.image.newImageData('res/images/testMask.png')
	p = player.make()
end

function love.update(dt)
	screen:update(dt)	
	mouseX,mouseY = love.mouse.getX()+screen.cameras[1]._x,love.mouse.getY()+screen.cameras[1]._y
	----
	p:update(dt)
	local cx,cy = screen.cameras[1]._x+(screen.cameras[1]._width/2),screen.cameras[1]._y+(screen.cameras[1]._height/2)
	local cpd = (((cx-p.x)^2)+((cy-p.y)^2))^.5
	if cpd > 64 then
		screen.cameras[1]:move(-math.round(math.cos(math.atan2((cy-p.y),(cx-p.x)))*(cpd)/(128/p.speed),1))
		screen.cameras[1]:move(0,-math.round(math.sin(math.atan2((cy-p.y),(cx-p.x)))*(cpd)/(128/p.speed),1))
	end
end

function love.draw()
		screen:setChromaticFilter()
		screen:draw()
		------
		screen.cameras[1]:set()
		-- for i=0,math.floor(screen.cameras[1]._width/48) do
		-- for ii = 0, math.floor(screen.cameras[1]._height/48) do
		-- 	love.graphics.rectangle('fill',(math.floor(screen.cameras[1]._x/48)*48)+(i*48),(math.floor(screen.cameras[1]._y/48)*48)+(ii*48),24,24)
		-- end
		-- end
	love.graphics.draw(walkMask)
	p:draw()

	love.graphics.setColor(0,128,255,128)
	love.graphics.line(mouseX,screen.cameras[1]._y,mouseX,mouseY)
	love.graphics.circle('fill',mouseX,mouseY,24,4)
		screen.cameras[1]:release()
		------
		screen:releaseChromaticFilter()
end

function love.mousepressed(x,y,button)
	p:mousepressed(mouseX,mouseY,button)
end

function  love.mousereleased(x,y,button)
	p:mousereleased(mouseX,mouseY,button)
end

function  love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	elseif k == ' ' then
		screen:shake()
	end
end