function splitString(str,del)
	local t = {}
	local c = 0
	while c do
		table.insert(t,str:sub(c+1,((str:find(del or ' ',c+1)) or 0)-1))
		c = str:find(del or  ' ',c+1)
	end
	return t
end

function atoi(s)
	local i = 0
	for c in s:gmatch("%d") do i = i*10+c end
	return i
end

function hexToCol(h)
	local t
	for c in h:gmatch(".") do
		t = (t or '')..c..','
	end
	t = t:gsub("%a",function (s) return s:lower():byte()-87 end)
	t = splitString(t,",")
	return {t[2]*16+t[3],t[4]*16+t[5],t[6]*16+t[7]}
end

function loadEvents()
	local events = {}
	for i,f in ipairs(love.filesystem.getDirectoryItems("")) do
		if f:sub(-4,-1) == ".spt" then
			print(f)
			-- local file = love.filesystem.newFile(f)
			local file = io.open(f,'r')
			for l in file:lines() do
				print(l)
				local e = splitString(l,',')
				for ii,x in ipairs(e) do
					print(ii,x,type(x))
				end
				events[e[6] or "event"..math.random()] = e
			end
		end
	end
	return events
end

function updateEvents(events,x,y,button)
	for i,e in pairs(events) do
		if x > atoi(e[1]) and x < atoi(e[1])+atoi(e[3]) and
			y > atoi(e[2]) and y < atoi(e[2])+atoi(e[4]) then
			print("Attempting to execute script \""..i.."\"")
			local er, event
			er, event = pcall( love.filesystem.load, "scripts/"..e[5])
			er = pcall(event)
			if er then print("[OK]") else print("[FAIL] script "..e[5].." couldn't load") end
		end
	end
end