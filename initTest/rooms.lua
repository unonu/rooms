room = {}
room.__index = room

function room.make(x, y, z, w, h, doors, stairs, chests)
	local r = {}
	setmetatable(r,room)
	r.x = x
	r.y = y
	r.z = z
	r.width = w
	r.height = h
	r.doors = doors--{}
	r.stairs = stairs--{}
	r.chests = chests--{}
--	for i = 1, math.floor(#doors/2) do
--		local d = {}
--		d.x = doors[((i-1)*2)]
--		d.y = doors[((i-1)*2)+1]
--		table.insert(r.doors, d)
--	end
--	for i = 1, math.floor(#stairs/2) do
--		local s = {}
--		s.x = stairs[((i-1)*2)]
--		s.y = stairs[((i-1)*2)+1]
--		table.insert(r.stairs, s)
--	end
--	for i = 1, math.floor(#chests/2) do
--		local c = {}
--		c.x = chests[((i-1)*2)]
--		c.y = chests[((i-1)*2)+1]
--		table.insert(r.chests, c)
--	end
	r.tiles = {}
	for i = 0, r.width - 1 do
		for ii = 0, r.height - 1 do
			local a = tile.make(i,ii,1)
			for iii,s in ipairs(r.stairs) do
				if s.x == i and s.y == ii then
					a.class = 'stair'
				end
			end
			for iii,s in ipairs(r.chests) do
				if s.x == i and s.y == ii then
					a.class = 'chest'
				end
			end
			print('Made tile '..i..', '..ii..' class '..a.class)
			table.insert(r.tiles,a)
		end
	end
	for i,d in ipairs(r.doors) do
		if d.wall == 'e' then
			local a = tile.make(r.width,d.pos - 1,1,'door')
			table.insert(r.tiles,a)
		elseif d.wall == 'w' then
			local a = tile.make(-1,d.pos - 1,1,'door')
			table.insert(r.tiles,a)
		elseif d.wall == 'n' then
			local a = tile.make(d.pos - 1,-1,1,'door')
			table.insert(r.tiles,a)
		elseif d.wall == 's' then
			local a = tile.make(d.pos - 1,r.height,1,'door')
			table.insert(r.tiles,a)
		end
	end
--	print('lat walls')
--	for i = -1, r.width + 1 do
--		for ii,d in ipairs(r.doors) do
--			if d.wall == 'n' and d.pos - 1 == i then
--				print('door in the way')
--			else
--				local a = tile.make(i - 1,-1,3,'wall')
--				print('made wall')
--				table.insert(r.tiles,a)
--			end
--			if d.wall == 's' and d.pos - 1 == i then
--				print('door in the way')
--			else
--				local a = tile.make(i - 1,r.height+1,3,'wall')
--				print('made wall')
--				table.insert(r.tiles,a)
--			end
--		end
--	end
--	print('long walls')
--	for i = 0, r.height + 1 do
--		for ii,d in ipairs(r.doors) do
--			if d.wall == 'e' and d.pos == i then
--				print('door in the way')
--			else
--				local a = tile.make(r.width,i - 1,3,'wall')
--				print('made wall')
--				table.insert(r.tiles,a)
--			end
--			if d.wall == 'w' and d.pos == i then
--				print('door in the way')
--			else
--				local a = tile.make(-1,i - 1,3,'wall')
--				print('made wall')
--				table.insert(r.tiles,a)
--			end
--		end
--	end
	print('End room.make()')
	
	return r
end

function room:draw()
	camera:set()

---------------------------------------------
	for yy = -1, self.height + 1 do
		for xx = self.width + 1, -1, -1 do
			for y,t in pairs(self.tiles) do
				if t.gy == yy then
					if t.gx == xx then
						t:draw(self.x, self.y)					
					end
				end
			end
--	xx = xx + 1
		end
--	yy = yy + 1
	end
	camera:unset()
---------------------------------------------
	love.graphics.setColor(255,0,0)
	love.graphics.print('x: '..self.x..', y: '..self.y..', z: '..self.z..'\n'..'w: '..self.width..', h: '..self.height..'\n'..#self.doors..' doors, '..#self.stairs..' stairs,\n'..#self.chests..' chests',0,0)
end

---------------------------------------------------------

function loadMap(map)
	local map = love.image.newImageData(map..'.png')
	local mapWidth, mapHeight = map:getWidth(), map:getHeight()
	print('Map width, height: '..mapWidth..', '..mapHeight)
	local readX, readY = 0,0
	local minX, minY, maxX, maxY = 0,0,0,0
	local doneWithWalls = false
	local readTable = {}
	local rooms = {}
	while not doneWithWalls do
		local firstStage, secondStage, thirdStage = true, true, true
		print('init '..readX..', '..readY)
		readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
		while firstStage do
--			if readTable.r ~= 255 and readTable.g ~= 0 and readTable.b ~= 0 then
--				print(readX..', '..readY)
--				if readX <= mapWidth - 2 then
--					readX = readX + 1
--				else
--					readX = 0
--					if readY <= mapHeight - 2 then
--						readY = readY + 1
--					else
--						break
--					end
--				end
--				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
--				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
--				print('one pass')
--			else
--				firstStage = false
--			end
			if readTable.r == 255 and readTable.g == 0 and readTable.b == 0 then
				firstStage = false
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
			else
				print(readX..', '..readY)
				if readX <= mapWidth - 2 then
					readX = readX + 1
				else
					readX = 0
					if readY <= mapHeight - 2 then
						readY = readY + 1
					else
						break
					end
				end
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
				print('one pass')
			end
		end
		print('found corner')
		minX = readX
		minY = readY
		print('set mins '..minX..', '..minY)
		print('     going right')
		readX = readX + 1
		readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
		print(readX..', '..readY..' for maxX')
		while secondStage do
--			if readTable.r ~= 255 and readTable.g ~= 0 and readTable.b ~= 0 then
--				readX = readX + 1
--				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
--				print(readX..', '..readY..' for maxX')
--			else
--				secondStage = false
--				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
--			end
			if readTable.r == 255 and readTable.g == 0 and readTable.b == 0 then
				secondStage = false
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)				
			else		
				readX = readX + 1
				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)				
				print(readX..', '..readY..' for maxX')
			end
		end
		maxX = readX
		print('set maxX '..maxX)
		print('     going down')
		readY = readY + 1
		readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
		while thirdStage do
--			if readTable.r ~= 255 and readTable.g ~= 128 and readTable.b ~= 0 then
--				readY = readY + 1
--				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
--				print(readX..', '..readY..' for maxY')
--			else
--				thirdStage = false
--				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
--			end
			if readTable.r == 255 and readTable.g == 128 and readTable.b == 0 then
				thirdStage = false
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
			else
				readY = readY + 1
				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(readX,readY)
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
				print(readX..', '..readY..' for maxY')
			end
		end
		maxY = readY
		print('set maxY '..maxY)
		local tempRoom = {}
		tempRoom.x = minX
		tempRoom.y = minY
		tempRoom.width = maxX - minX - 1
		tempRoom.height = maxY - minY - 1
		tempRoom.doors = {}
		tempRoom.chests = {}
		tempRoom.stairs = {}
		table.insert(rooms, tempRoom)
		print('--------------------\nMade room at '..tempRoom.x..', '..tempRoom.y..', '..tempRoom.width..' wide and '..tempRoom.height..' tall\n-------------------')
		if readX == mapWidth - 1 and readY == mapHeight - 1 then
			doneWithWalls = true
		else
			print('not done, going back')
			if readX < mapWidth - 2 then
				readX = maxX + 1
				readY = minY
			else
				readX = 0
				readY = minY + 1
			end
		end
	end
	print('found '..#rooms..' rooms')
	------------------------------------
	-- Stuff in rooms
	------------------------------------
	print('\n--populating rooms-------------\n')
	
	for iii, r in ipairs(rooms) do
		print('Start Room -------------')
		readX = r.x
		readY = r.y
		for i = readX, r.x + r.width + 1 do
			for ii = readY, r.y + r.height + 1 do
				print('read '..i..', '..ii)
				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(i,ii)
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
				
				if readTable.r == 0 and readTable.g == 255 and readTable.b == 0 then
					local door = {}
					if i > readX and ii > readY and ii < readY + r.height + 1 then
						door.wall = 'e'
						door.pos = ii - readY
					elseif i > readX and ii == readY then
						door.wall = 'n'
						door.pos = i - readX
					elseif i > readX and ii == readY + r.height + 1 then
						door.wall = 's'
						door.pos = i - readX
					elseif i == readX and ii > readY and ii < readY + r.height + 1 then
						door.wall = 'w'
						door.pos = ii - readY
					end
					print('made door '..door.wall..' at pos '..door.pos)
					table.insert(r.doors, door)
				end
			end
		end
		print('No more doors -------------')
		--------------------------------------------------------------
		readX = r.x + 1
		readY = r.y + 1
		for i = readX, readX + r.width - 1 do
			for ii = readY, readY + r.height - 1 do
				print('read '..i..', '..ii)
				readTable.r, readTable.g, readTable.b, readTable.a = map:getPixel(i,ii)
				print('rgb: '..readTable.r..', '..readTable.g..', '..readTable.b)
				
				if readTable.r == 0 and readTable.g == 0 and readTable.b == 255 then
					local stair = {x = i - readX, y = ii - readY}
					print('stair at '..stair.x..', '..stair.y)
					table.insert(r.stairs, stair)
				elseif readTable.r == 255 and readTable.g == 255 and readTable.b == 0 then
					local chest = {x = i - readX, y = ii - readY}
					print('chest at '..chest.x..', '..chest.y)
					table.insert(r.chests, chest)
				end
			end
		end
		print('no more stuffing')
		print('End room')
	end
	----------------------------------------------------------------------
	local outRooms = {}
	for i, r in ipairs(rooms) do
		table.insert(outRooms,room.make(r.x,r.y,  1  ,r.width,r.height,r.doors, r.stairs, r.chests))
	end
	return outRooms
end
