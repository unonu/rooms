res = {}

res.images = {}
res.sounds = {}
res.music = {}
res.quads = {}
res.tilesets = {}

function indexRes()
	local files = love.filesystem.enumerate('res/images')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.png' then
			local item = {val = nil, users = 0}
			res.images[b]=item
		end
	end
	local files = love.filesystem.enumerate('res/sounds')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.mp3' then
			local item = {val = nil, users = 0}
			res.sounds[b]=item
		end
	end
	local files = love.filesystem.enumerate('res/music')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.mp3' then
			local item = {val = nil, users = 0}
			res.music[b]=item
		end
	end
	local files = love.filesystem.enumerate('res/tilesets')
	for i, b in ipairs(files) do
		if string.sub(b,-4) == '.png' then
			local item = {val = nil, users = 0}
			res.tilesets[b]=item
		elseif string.sub(b,-5) == '.quad' then
			print(b)
			local item = love.filesystem.newFile('res/tilesets/'..b)
			item:open('r')
			local data = ' '
--print(data)
--print('----')
			local doLoop = true
			local ry = 0
			while doLoop do
--print('in loop')
				local rx = 1
				local val = 0
				local quad = {}
				local newLine = false
				data = item:read(1)
--print('newline - '..data)
				while not newLine do
--print('inter loop - '..data)
					if data == '\n' or item:eof() then
						newLine = true
--print('fond a \\n or eof')
--print(type(val)..' - '..val)
						rx = rx+1
						val = 0
--print('     next line')
					elseif data ~= ',' then
						val =  (10*val) + (tonumber(data))
--print('not a \',\' - '..tonumber(data))
						quad[rx] = val
--print('inserted '..val..' into quad table at '..rx)
						data = item:read(1)
					else
--print(type(val)..' - '..val)
						rx = rx+1
						val = 0
--print(',')
						data = item:read(1)
					end
				end
				ry = ry+1
				if item:eof() then
					doLoop = false
--print('no more do loop')
				end
--print(string.sub(b,1,-6)..ry)
--print(quad[1]..','..quad[2]..','..quad[3]..','..quad[4]..','..quad[5]..','..quad[6]..','..quad[7])
				res.quads[string.sub(b,1,-6)..ry]= love.graphics.newQuad(quad[1],quad[2],quad[3],quad[4],quad[5],quad[6],quad[7])
			end
--print('----')
			item:close()
			print('loaded quad sheet')
		end
	end
end

function loadRes(typ, name)	
	if typ == 'image' and (res.images[name].users == 0 or res.images[name].val == nil) then
		res.images[name].users = res.images[name].users + 1
		res.images[name].val = love.graphics.newImage('res/images/'..name)
		return res.images[name].val 
	elseif typ == 'sound' and (res.sounds[name].users == 0 or res.sounds[name].val == nil) then
		res.sounds[name].users = res.sounds[name].users + 1
		res.sounds[name].val = love.graphics.newImage('res/sounds/'..name)
		return res.sounds[name].val 
	elseif typ == 'music' and (res.music[name].users == 0 or res.music[name].val == nil) then
		res.music[name].users = res.music[name].users + 1
		res.music[name].val = love.graphics.newImage('res/music/'..name)
		return res.music[name].val  
	elseif typ == 'tileset' and (res.tilesets[name].users == 0 or res.tilesets[name].val == nil) then
		res.tilesets[name].users = res.tilesets[name].users + 1
		res.tilesets[name].val = love.graphics.newImage('res/tilesets/'..name)
		return res.tilesets[name].val 
	elseif typ == 'quad' then
		return res.quads[name]
	else 
		if typ == 'music' then
			res.music[name].users = loc[name].users + 1
			return res.music[name].val
		else
			local loc = res[typ..'s']
			loc[name].users = loc[name].users + 1
			return loc[name].val
		end
	end
end


-------------------------------------------------------------------------------------------------------------------------
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
-------------------------------------------------------------------------------------------------------------------------

dungeon = {}
dungeon.__index = dungeon

function dungeon.make(input)
	local d = {}
	setmetatable(d, dungeon)
	local file = love.filesystem.newFile('dungeons/'..input..'.dgn')
	file:open('r')
	local map = love.image.newImageData('dungeons/'..input..'.png')
	--entrance, room, miniboss, boss, exit
	--read dungeon file
	local read = {}
	read.buffer = nil
	local doLoop = true
	while doLoop do
		-- print('anything!!!!')
		if not read.buffer then
			read.buffer = file:read(1)
			-- print(read.buffer)
		else
			read.buffer = read.buffer..file:read(1)
			-- print(read.buffer)
		end
		--
		if read.buffer == 'name' then
			print('found name')
			read.buffer = nil
			read.cur = file:read(1)
			while read.cur ~= '\n' do
				if not read.buffer then
					read.cur = file:read(1)
					read.buffer = read.cur
				else
					read.cur = file:read(1)
					read.buffer = read.buffer..read.cur
				end
			end
			d.name = read.buffer
			print(read.buffer)
			read.buffer = nil
		end
		if read.buffer == 'level' then
			print('found level')
			read.buffer = nil
			read.cur = file:read(1)
			while read.cur ~= '\n' do
				if not read.buffer then
					read.cur = file:read(1)
					read.buffer = read.cur
				else
					read.cur = file:read(1)
					read.buffer = read.buffer..read.cur
				end
			end
			d.level = tonumber(read.buffer)
			print(read.buffer)
			read.buffer = nil
		end
		if read.buffer == 'tileset' then
			print('found tileset')
			read.buffer = nil
			read.cur = file:read(1)
			while read.cur ~= '\n' do
				if not read.buffer then
					read.cur = file:read(1)
					read.buffer = read.cur
				else
					read.cur = file:read(1)
					read.buffer = read.buffer..read.cur
				end
			end
			d.tileset = read.buffer
			print(read.buffer)
			read.buffer = nil
		end
		if read.buffer == 'width' then
			print('found width')
			read.buffer = nil
			read.cur = file:read(1)
			while read.cur ~= '\n' do
				if not read.buffer then
					read.cur = file:read(1)
					read.buffer = read.cur
				else
					read.cur = file:read(1)
					read.buffer = read.buffer..read.cur
				end
			end
			d.width = tonumber(read.buffer)
			print(read.buffer)
			read.buffer = nil
		end
		if read.buffer == 'height' then
			print('found height')
			read.buffer = nil
			read.cur = file:read(1)
			while read.cur ~= '\n' do
				if not read.buffer then
					read.cur = file:read(1)
					read.buffer = read.cur
				else
					read.cur = file:read(1)
					read.buffer = read.buffer..read.cur
				end
			end
			d.height = tonumber(read.buffer)
			print(read.buffer)
			read.buffer = nil
			doLoop = false
		end

		if file:eof() then
			doLoop = false
			print('done looping')
		end
	end
	print('read level config file')
	-- d.width = map:getWidth()/8
	-- d.height = file:getHeight()/8
	-- d.name = file
	d.rooms = {}

	--read map image
	for i=0, d.height-1 do
	for ii=0, d.width-1 do
		local data = {}
		local read = {}
		for px = 0, 7 do
		for py = 7, 0, -1 do
			read.r, read.g, read.b, read.a = map:getPixel((ii*8)+px,(i*8)+py)
			-- print(read.r..' '..read.g..' '..read.b)
			if read.r == 191 and read.g == 191 and read.b == 191 and read.a == 255 then
				table.insert(data,1)
			elseif read.r == 255 and read.g == 255 and read.b == 255 and read.a == 255 then
				table.insert(data,5)
			else
				table.insert(data,1.5)
			end
		end
		end
		-- print('----')
		table.insert(d.rooms,room.make(ii,i,data,'room'))
	end
	end
	return d
end
