tile = {}
tile.__index = tile
function tile.make(x,y,z,class)
	local t = {}
	setmetatable(t,tile)
	
	t.gx = x
	t.gy = y
	t.gz = z
	t.x = x*24+y*24
	t.y = (y*8-((x-1)*8))
	t.z = z
	t.class =  class or 'floor'
	
	return t
end

function tile:draw(refX,refY)
	--0--0--0--TOP--0--0--0--
		if self.class == 'floor' then
			love.graphics.setColor(210,210,210)
		elseif self.class == 'door' then
			love.graphics.setColor(0,210,0)
		elseif self.class == 'stair' then
			love.graphics.setColor(0,0,210)
		elseif self.class == 'chest' then
			love.graphics.setColor(210,210,0)
		elseif self.class == 'wall' then
			love.graphics.setColor(100,100,100)
		end
	love.graphics.polygon('fill', ((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y-8-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8), ((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8))
		love.graphics.setColor(24,24,24)
	love.graphics.polygon('line',((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y-8-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8))
	--0--0--0--LEFT--0--0--0--
--		love.graphics.setColor(150,140,140)
--	love.graphics.polygon('fill',((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+16,((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y+8,((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8))
--		love.graphics.setColor(24,24,24)
--	love.graphics.polygon('line',((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+16,((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y+8,((refX*24)+(refY*24)) + self.x, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8))
	--0--0--0--RIGHT--0--0--0--
--		love.graphics.setColor(80,75,75)
--	love.graphics.polygon('fill',((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y+8,((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+16,((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8))
--		love.graphics.setColor(24,24,24)
--	love.graphics.polygon('line',((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y-(self.z*8),((refX*24)+(refY*24)) + self.x+48, ((refY*8)-((refX-1)*8)) + self.y+8,((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+16,((refX*24)+(refY*24)) + self.x+24, ((refY*8)-((refX-1)*8)) + self.y+8-(self.z*8))
	
end
