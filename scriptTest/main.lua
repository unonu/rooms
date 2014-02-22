require("scripts")

function love.load()
	love.graphics.setBackgroundColor(hexToCol("#00FF00"))
	events = loadEvents()
end

function love.draw()
	love.graphics.setColor(255,255,255)
	for i,e in pairs(events) do
		love.graphics.rectangle('fill',atoi(e[1]),atoi(e[2]),atoi(e[3]),atoi(e[4]))
	end
end

function love.update(dt)

end

function love.mousepressed( x,y,button )
	updateEvents(events,x,y,button)
end

function love.keypressed( k )
	if k == 'escape' then love.event.quit() end
end