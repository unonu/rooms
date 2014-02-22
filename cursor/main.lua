function love.load()
	love.mouse.setGrabbed(true)
	love.mouse.setVisible(false)
	tempPoints = {0,0}
	dataPoints = {}
	active = false
	step = 0
	directions = {}
	segments = {}
end

function love.update(dt)
	mousex,mousey = love.mouse.getPosition()
	if active then
		if step <= 1 then
			table.insert(tempPoints,mousex)
			table.insert(tempPoints,mousey)
		end
		table.insert(dataPoints,mousex)
		table.insert(dataPoints,mousey)
		step = step + 1
		if step == 4 then step = 0 end
		if math.abs(tempPoints[#tempPoints-3]-tempPoints[#tempPoints-1]) - math.abs(tempPoints[#tempPoints-2]-tempPoints[#tempPoints]) >= 86 then
			if tempPoints[#tempPoints-3] < tempPoints[#tempPoints-1] then
				makeSegment()
			elseif tempPoints[#tempPoints-3] > tempPoints[#tempPoints-1] then
				makeSegment()
			end
			-- print('horiz')
		elseif math.abs(tempPoints[#tempPoints-3]-tempPoints[#tempPoints-1]) - math.abs(tempPoints[#tempPoints-2]-tempPoints[#tempPoints]) <= -86 then
			if tempPoints[#tempPoints-2] < tempPoints[#tempPoints] then
				makeSegment()
			elseif tempPoints[#tempPoints-2] > tempPoints[#tempPoints] then
				makeSegment()
			end
			-- print('vert')
		elseif math.abs(math.abs(tempPoints[#tempPoints-3]-tempPoints[#tempPoints-1]) - math.abs(tempPoints[#tempPoints-2]-tempPoints[#tempPoints])) < 86
		and ((tempPoints[#tempPoints-3]-tempPoints[#tempPoints-1])^2+(tempPoints[#tempPoints-2]-tempPoints[#tempPoints])^2)^.5 >= 96 then
			if tempPoints[#tempPoints-3] < tempPoints[#tempPoints-1] then
				if tempPoints[#tempPoints-2] < tempPoints[#tempPoints] then
					makeSegment()
				elseif tempPoints[#tempPoints-2] > tempPoints[#tempPoints] then
					makeSegment()
				end
			elseif tempPoints[#tempPoints-3] > tempPoints[#tempPoints-1] then
				if tempPoints[#tempPoints-2] < tempPoints[#tempPoints] then
					makeSegment()
				elseif tempPoints[#tempPoints-2] > tempPoints[#tempPoints] then
					makeSegment()
				end
			end
			-- print('diag')
		end
	else
		-- tempPoints = {mousex,mousey}
		dataPoints = {mousex,mousey}
		step = 0
	end
	if #tempPoints > 128 then table.remove(tempPoints,1); table.remove(tempPoints,1) end
	if #dataPoints > 128 then table.remove(dataPoints,1); table.remove(dataPoints,1) end
end

function love.draw()
	if active then
		love.graphics.setColor(255,0,0)
		love.graphics.setLineWidth(2)
		-- print(unpack(dataPoints))
		love.graphics.line(unpack(dataPoints))
	else 
		love.graphics.setColor(255,255,255)
	end
	love.graphics.point(mousex,mousey)

	if #tempPoints >= 4 then
		love.graphics.setColor(0,128,255,128)
		love.graphics.setLineWidth(4)
		-- print(unpack(tempPoints))
		love.graphics.line(unpack(tempPoints))
	end

	love.graphics.setColor(255,255,0)
	for i,s in ipairs(segments) do
		love.graphics.line(unpack(s))
	end
end

function love.mousepressed(x,y,button)
	if button == 'l' then
		active = true
		tempPoints = {mousex,mousey}
		dataPoints = {mousex,mousey}
		segments = {}
	end
end

function love.mousereleased(x,y,button)
	if button == 'l' then active = false;analyse(tempPoints);directions = {} end
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
end

function makeSegment()
	if #segments == 0 then
		table.insert(segments,{tempPoints[1],tempPoints[2],tempPoints[#tempPoints-1],tempPoints[#tempPoints]})
	else
		table.insert(segments,{segments[#segments][3],segments[#segments][4],tempPoints[#tempPoints-1],tempPoints[#tempPoints]})
		if math.abs(((-math.atan2(segments[#segments-1][2]-segments[#segments-1][4],segments[#segments-1][1]-segments[#segments-1][3]))+(math.pi)) - ((-math.atan2(segments[#segments][2]-segments[#segments][4],segments[#segments][1]-segments[#segments][3]))+(math.pi))) < math.pi/4
		or math.abs(((-math.atan2(segments[#segments-1][2]-segments[#segments-1][4],segments[#segments-1][1]-segments[#segments-1][3]))+(math.pi)) - ((-math.atan2(segments[#segments][2]-segments[#segments][4],segments[#segments][1]-segments[#segments][3]))+(math.pi))) > 7*math.pi/4 then
			-- print('optimising')
			segments[#segments-1][3] = segments[#segments][3]
			segments[#segments-1][4] = segments[#segments][4]
			table.remove(segments,#segments)
		end
	end
	if ((segments[#segments][1]-segments[#segments][3])^2+(segments[#segments][2]-segments[#segments][4])^2)^.5 < 96 then
		table.remove(segments,#segments)
	end
end

function analyse(data)
	local intersections = {}
	local circuit = false
	for i,s in ipairs(segments) do
		local r = -math.atan2(s[2]-s[4],s[1]-s[3])+math.pi
		-- print(r)
		if r < math.pi/8 or r >= 15*math.pi/8 then
			table.insert(directions,'right')
		elseif r >= math.pi/8 and r < 3*math.pi/8 then
			table.insert(directions,'upRight')
		elseif r >= 3*math.pi/8 and r < 5*math.pi/8 then
			table.insert(directions,'up')
		elseif r >= 5*math.pi/8 and r < 7*math.pi/8 then
			table.insert(directions,'upLeft')
		elseif r >= 7*math.pi/8 and r < 9*math.pi/8 then
			table.insert(directions,'left')
		elseif r >= 9*math.pi/8 and r < 11*math.pi/8 then
			table.insert(directions,'downLeft')
		elseif r >= 11*math.pi/8 and r < 13*math.pi/8 then
			table.insert(directions,'down')
		elseif r >= 13*math.pi/8 and r < 15*math.pi/8 then
			table.insert(directions,'downRight')
		end
		-- print(#directions,'a')
		
		for ii =1,math.min(#segments,8) do
			if #intersections < 8 then
			local ss = segments[ii]
			-- print(i,ii)
			if ii<i-1 or ii>i+1 then
				-- print('valid')
				if math.checkIntersect({s[1],s[2]},{s[3],s[4]},{ss[1],ss[2]},{ss[3],ss[4]}) then
					local pair, clear = {math.min(i,ii),math.max(i,ii)}, true
					-- print("intersect between "..pair[1]..','..pair[2])
					for iii,int in ipairs(intersections) do
						if int[1] == pair[1] and int[2] == pair[2] then clear = false end
						-- print('a',int,pair)
					end
					if clear then table.insert(intersections,pair) end
				end
			end
			end
		end
	end
	-- print(#intersections..' intersections')
	if #intersections >0 then circuit = true end
	-- print(unpack(directions))
	-- print(#segments..' segments')
end

-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

-- Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function math.checkIntersect(l1p1, l1p2, l2p1, l2p2)
    local function checkDir(pt1, pt2, pt3) return math.sign(((pt2[1]-pt1[1])*(pt3[2]-pt1[2])) - ((pt3[1]-pt1[1])*(pt2[2]-pt1[2]))) end
    return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

-- Normalizes a table of numbers.
function math.normalize(t) local n,m = #t,0 for i=1,n do m=m+t[i] end m=1/m for i=1,n do t[i]=t[i]*m end return t end