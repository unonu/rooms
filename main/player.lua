function initPlayer()
	local p = {}
	p.name = 'Heathlock'
	p.location = {_x = 0, _y = 0, _z = 0,prevX = nil, prevY = nil, prevZ = nil}
	p.width = 1
	p.height = 1
	p.stats = {hp = 4,mp = 4}
	p.hp = 4
	p.mp = 4
	p.inventory = {}
	p.primary = nil
	p.secondary = nil
	p.hotbar = {}
	p.level = 0
	p.res = {}
	p.res.image = loadRes('image','tempPlayer.png')
	p.colBox = {x = p.location._x,y = p.location._y,width = 56 , height = 82}
	
	function p:setPrev()
		self.location.prevZ = self.location._z
		self.location.prevY = self.location._y
		sslf.location.prevX = self.location._x
	end

	function p:move(dx,dy)
		self.location._x = self.location._x + (dx or 0)
		self.location._y = self.location._y + (dy or 0)
	end

	function p:setColissionBox(x,y,w,h)
		
	end
	
	function p:draw()
			love.graphics.draw(self.res.image, self.location._x, self.location._y)
	end

	return p
end
