-- require('lib/ansicolours')
require('lib/orea')
require('lib/res')

function love.load()
	fonts = loadFonts()
	love.graphics.setFont(fonts.boomMedium)
	time = 72000
	today = 0
	timeStep = 1
	day = 86400
	timeFuzzy = 'midnight'
	weather = 'clear'
	weathers = {'clear','overcast','showers','downpoor','hot','humid','stormy','windy'}
	timeNames = {'midnight','early','morning','noon','afternoon','evening','night'}
	times = {midnight = 0,early=day/6,morning=day/4,noon=day/2,afternoon=day*13/24,evening=day*17/24,night=day*5/6}
	colorCorrection = {255,255,255}
	colors = {}
		colors.midnight = {0,12,48}
		colors.early = {64,50,86}
		colors.morning = {208,220,222}
		colors.noon = {255,255,255}
		colors.afternoon = {255,240,230}
		colors.evening = {125,75,90}
		colors.night = {0,28,112}
		colors.clear = {}
		colors.overcast = {}
		colors.showers = {}
		colors.downpoor = {}
		colors.hot = {}
		colors.humid = {}
		colors.stormy = {}
		colors.windy = {}
	timeColor = {unpack(colors[timeFuzzy])}
	--
	block = love.graphics.newImage('testBlock.png')
end

function love.update(dt)
	-- print(unpack(colors[timeFuzzy]))
	for i,t in pairs(times) do
		if time == t then timeFuzzy = i end
	end
	if time == 0 then today = today + 1 end
	time = math.loop(0,time+timeStep,day)
	-- print(unpack(colors[timeFuzzy]))

	--if time >= times[timeNames[math.loop(1,table.getIndex(timeNames,timeFuzzy)+1,7)]]-math.max(unpack(colors[timeNames[math.loop(1,table.getIndex(timeNames,timeFuzzy)+1,7)]])) then
	-- print(math.loop(1,table.getIndex(timeNames,timeFuzzy)+1,7))
	-- print(times[timeNames[math.loop(1,table.getIndex(timeNames,timeFuzzy)+1,7)]] - 7200 )
	local nextFuzzy = timeNames[math.loop(1,table.getIndex(timeNames,timeFuzzy)+1,7)]
	if time >= times[nextFuzzy] - 7200 then
		for i = 1, 3 do
	-- print(unpack(colors[timeFuzzy]))
			if timeColor[i] < colors[nextFuzzy][i] then
				-- print(unpack(colors[timeFuzzy]))
				timeColor[i] = timeColor[i] + (colors[nextFuzzy][i]-colors[timeFuzzy][i])/7200
				-- print(unpack(colors[timeFuzzy]))
				-- print(colors[nextFuzzy][i],colors[timeFuzzy][i])
				-- print((colors[nextFuzzy][i]-colors[timeFuzzy][i])/7200)
				-- print(timeColor[i])
			elseif timeColor[i] > colors[nextFuzzy][i] then
				timeColor[i] = timeColor[i] - (colors[nextFuzzy][i]-colors[timeFuzzy][i])/7200
				-- print(timeColor[i])
			end
	-- print(unpack(colors[timeFuzzy]))
		end
		-- print('--')
	end
	-- print(unpack(colors[timeFuzzy]))
	-- print()
end

function love.draw()
	love.graphics.setBackgroundColor(unpack(timeColor))
	love.graphics.draw(block,128,128)
	--
	love.graphics.print(time,0,0)
	love.graphics.print('DAY '..today,0,26)
	love.graphics.print(string.upper(timeFuzzy),0,52)
end

function love.keypressed(k)
	if k == '=' or k == '+' then
		timeStep = math.min(timeStep+1,100)
	elseif k == '-' or k == '_' then
		timeStep = math.max(timeStep-1,0)
	elseif k == 'escape' then
		love.event.quit()
	end
end