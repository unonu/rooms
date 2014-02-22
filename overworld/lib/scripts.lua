function loadEvents(dir)
	local events = {}
	for i,f in ipairs(love.filesystem.getDirectoryItems(dir or "")) do
		if f:sub(-4,-1) == ".spt" then
			print(f,dir..'/'..f)
			local file = io.open(dir..'/'..f,'r')
			for l in file:lines() do
				print(l)
				local e = splitString(l,',')
				for ii,x in ipairs(e) do
					print(ii,x,type(x))
				end
				function e:call()
					print("Attempting to execute script \""..self[1].."\"")
					local er, event
					er, event = pcall( love.filesystem.load, (dir or "")..self[1]..".lua")
					er = pcall(event)
					if er then print("[OK]") else print("[FAIL] script "..self[1]..".lua couldn't load") end
				end
				events[e[2] or "event"..math.random()] = e
			end
		end
	end
	return events
end

-- function updateEvents(events,x,y,button)
-- 	for i,e in pairs(events) do
-- 		if x > atoi(e[1]) and x < atoi(e[1])+atoi(e[3]) and
-- 			y > atoi(e[2]) and y < atoi(e[2])+atoi(e[4]) then
-- 			print("Attempting to execute script \""..i.."\"")
-- 			local er, event
-- 			er, event = pcall( love.filesystem.load, "scripts/"..e[5])
-- 			er = pcall(event)
-- 			if er then print("[OK]") else print("[FAIL] script "..e[5].." couldn't load") end
-- 		end
-- 	end
-- end

-- function callEvent( name )
-- 	if
-- end
