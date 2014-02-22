room = {}
room.__index = room

function room.make(x,y,data,typ)
	local r = {}
	setmetatable(r,room)
	
	r.data = data -- 0 = floor, 1 = wall, .5 = platform, -1 = hole
	r.typ = typ or 'room'
	r.x,r.y =0,0

	r.tile = loadRes('tileset','prefabTiles.png')
	r.quads = {top = loadRes('quad','prefabTiles1'), mid = loadRes('quad','prefabTiles2'), bottom = loadRes('quad','prefabTiles3')}
	
	return r
end

function room:draw(x,y)
	-- love.graphics.point(x+0.5,y+0.5)
	for ii = 0, 7, 1 do
	for i = 7, 0, -1 do
--			love.graphics.setColor(255,255,255)
--		love.graphics.polygon('fill',x+((i*48)+(ii*48)),y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)-16 - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+96,y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+16 - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48)),y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64))

--		
--			love.graphics.setColor(150,128,128)
--		love.graphics.polygon('fill',x+((i*48)+(ii*48)),y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+16 - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+48,	x+((i*48)+(ii*48)),y+(ii*16)-(i*16)+32,	x+((i*48)+(ii*48)),y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64))
--		
--		
--			love.graphics.setColor(200,178,178)
--		love.graphics.polygon('fill',x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+16 - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+96,y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64),	x+((i*48)+(ii*48))+96,y+(ii*16)-(i*16)+32,	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+48,	x+((i*48)+(ii*48))+48,y+(ii*16)-(i*16)+16 - (self.data[i+(ii*8)+1]*64))
--		
--		
--		--------------------------------------------
--		
--		love.graphics.drawq(self.tile,self.quads.top,x+((i*48)+(ii*48)), y+(ii*16)-(i*16)-16 - (self.data[i+(ii*8)+1]*64))
--		
--		for c = (self.data[i+(ii*8)+1]*64)/16, 0, -1 do
--			love.graphics.drawq(self.tile,self.quads.mid, x+((i*48)+(ii*48)),(16*c) + y+(ii*16)-(i*16) - (self.data[i+(ii*8)+1]*64))
--		end
--		
--		love.graphics.drawq(self.tile,self.quads.bottom, x+((i*48)+(ii*48)), y+(ii*16)-(i*16)+32)

		if self.data[i+(ii*8)+1] == 1 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.drawq(self.tile,self.quads.top,x+((i*48)+(ii*48)), y+(ii*16)-(i*16)+32)
		elseif self.data[i+(ii*8)+1] == 5 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.drawq(self.tile,self.quads.bottom,x+((i*48)+(ii*48)), y+(ii*16)-(i*16)-16 - 80)
		elseif self.data[i+(ii*8)+1] == 1.5 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.drawq(self.tile,self.quads.mid,x+((i*48)+(ii*48)), y+(ii*16)-(i*16))
		end
	end
	end

	-- love.graphics.setColor(255,255,25,128)
	-- -- love.graphics.rectangle('fill',x,y,768,128)
	-- love.graphics.point(x+0.5,y+0.5)

end

