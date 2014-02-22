--only good for 0.8.0

jam = {}
function jam.load(dir)
	print(ansicolors.yellow..'Attempting to load joysticks from '..dir..'/joysticks'..'...'..ansicolors.clear)
	if love.joystick.getNumJoysticks() > 0 then
		local joysticks = {}
		for i=1, love.joystick.getNumJoysticks() do
			love.joystick.open(i)
			joysticks[love.joystick.getName(i)] = {}
		end
		------------------- configs
		love.filesystem.setIdentity(dir or 'temp')
		local configurations = love.filesystem.getDirectoryItems("joysticks") or {}
		print("Found these joystick config files:")
			for i,j in ipairs(configurations) do
				print('\t'..j)
			end
		for i,j in ipairs(configurations) do
		if string.sub(j,-1) ~= '~' and string.sub(j,0,1) ~= '~' then
			local file = love.filesystem.newFile("joysticks/"..j)
			file:open('r')
			local conf = {}
			local target = 'buttons'
			for l in file:lines() do
				if string.sub(l,0,1) == "#" then target = string.sub(l,2); conf[target]={} else
					conf[target][string.sub(l,string.find(l,'=')+2)] = string.sub(l,1,string.find(l,'=')-2)
					conf[target][string.sub(l,1,string.find(l,'=')-2)] = string.sub(l,string.find(l,'=')+2)
				end
			end
			if joysticks[string.sub(j,0,-5)] then
				joysticks[string.sub(j,0,-5)] = conf
			end
		end
		end
		-------------------
		if #configurations > 0 then
			for i,j in pairs(joysticks) do
				if j == {} then
					print(i,ansicolors.red.."*Not Ready*"..ansicolors.clear)
				else
					print(i,ansicolors.green.."*Ready*"..ansicolors.clear)
				end
			end
		else
			print(ansicolors.red.."No controller confiurations found!\nRunning configurator-inator"..ansicolors.clear)
		end
		return joysticks
	else
		print("No joysticks")
		return {}
	end
end

-- for 0.9.0
function jam.loadConfigs(dir)
	print(ansicolors.yellow..'Attempting to load joysticks from '..dir..'/joysticks'..'...'..ansicolors.clear)
	local joysticks = love.joystick.getJoysticks()
	love.filesystem.setIdentity(dir or 'temp')
	-- local configurations = love.filesystem.getDirectoryItems("joysticks") or {}
	-- for i,p in ipairs(configurations) do
	-- 	print(p)
	-- end
	for i,j in ipairs(joysticks) do
		print(j:getName()..'.joy',j:isGamepad())
		if love.filesystem.exists('joysticks/'..j:getName()..'.joy') then
			print('found config file for '..j:getName())
			local guid = j:getGUID()
			local inputType = 'button'
			local configuration = love.filesystem.newFile('joysticks/'..j:getName()..'.joy')
			configuration:open('r')
			for l in configuration:lines() do
				if string.sub(l,0,1) == "#" then inputType = string.sub(l,2); print(inputType) else
					if inputType ~= 'hat' then
						print(guid,string.sub(l,1,string.find(l,'=')-2),inputType,tonumber(string.sub(l,string.find(l,'=')+2)),type(tonumber(string.sub(l,string.find(l,'=')+2))))
						print(love.joystick.setGamepadMapping(guid,string.sub(l,1,string.find(l,'=')-2),inputType,tonumber(string.sub(l,string.find(l,'=')+2))))
						print(j:getGamepadMapping(string.sub(l,1,string.find(l,'=')-2)))
					else
						-- love.joystick.setGamepadMapping(guid,string.sub(l,1,string.find(l,'=')-2),inputType,string.sub(l,string.find(l,'=')+2))
					end
				end
			end
			configuration:close()
		else
			print('no such luck')
		end
		print(j:getName()..'.joy',j:isGamepad())
	end
end