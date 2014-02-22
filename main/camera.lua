camera = {}
camera._x = 0
camera._y = 0
camera._w = 0
camera._h = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
--if sx > 0.3 then
  sx = sx or 1
  self.scaleX = sx--self.scaleX * sx
  self.scaleY = sy or sx--self.scaleY * (sy or sx)
--end
	self._w = width*sx
	self._h = height*sx
end

function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end

function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera:update()
	if cameraMode == 'focused' then
	self:setPosition(players['player'..activePlayer].location.x-(width*self.scaleX/2),players['player'..activePlayer].location.y-(height*self.scaleX/2))
	self:scale(scale*players['player'..activePlayer].scale)
	else
		local lx, ly, mx, my, dx,dy = level.width,level.height,0,0,nil,nil
		for i, p in pairs(players) do
			if p.location.x - (96*scale) < lx then
				lx = p.location.x - (96*scale)
			end
			if p.location.x + p.width*p.scale + (96*scale) > mx then
				mx = p.location.x + p.width*p.scale + (96*scale)
			end
			if p.location.y - (96*scale) < ly then
				ly = p.location.y - (96*scale)
			end
			if p.location.y + p.height*p.scale + (96*scale) > my then
				my = p.location.y + p.height*p.scale + (96*scale)
			end
		end
		dx,dy = mx - lx, my - ly
		--[[print('lx: '..lx..' ly: '..ly)
		print('mx: '..mx..' my: '..my)
		print('dx: '..dx..' dy: '..dy)]]--

		if dx/width >= dy/height then
			if dx/width > .25 then
				self:scale(dx/width)
			end
		else
			if dy/height > .25 then
				self:scale(dy/height)
			end
		end
		self:setPosition((lx+(dx/2))-((width*self.scaleX)/2),(ly+(dy/2))-((height*self.scaleX)/2))
	end
end
