textbox = {}
textbox.__index = textbox

function textbox.make(text,x,y,auto,speed,delay,tremble,grab)
	local t = {}
	setmetatable(t,textbox)
	t.text = text or '...'
	if type(text) == 'string' then
		t.stageText = t.text
	elseif type(text) == 'table' then
		t.stageText = t.text[1]
	end
	t.x, t.y = x or 0,y or 0
	
	t.curText = ''
	t.place = 1
	t.counter = 1
	t.delay = delay or 10
	t.speed = speed or 1
	t.grab = grab
	
	t.tremble = tremble or false
	t.follow = false
	
	t.delayCounter = 0
	t.up = true
	t.done = false
	t.ready = false
	t.auto = auto or false
	
	return t
end

function textbox:draw()
	if self.tremble then
		love.graphics.push()
		love.graphics.translate(math.random(-2,2),math.random(-2,2))
	end
---- shadow
	love.graphics.setColor(0,0,0,128)
	love.graphics.rectangle('fill',self.x-2,self.y+2,204,64)
---- box
	love.graphics.setColor(200,200,200)
	love.graphics.rectangle('fill',self.x, self.y, 200,64)
	love.graphics.setColor(150,150,150)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('line',self.x+1,self.y+1,198,62)
---- text
	love.graphics.setColor(0,0,0)
	if self.ready then
		love.graphics.setColor(255,0,0)
	end
	if self.done then
		love.graphics.setColor(0,255,0)
	end
	love.graphics.printf(self.curText,self.x + 2,self.y + 2,200)
	
	if not self.auto and self.ready then
		love.graphics.setColor(255,200,0,255/math.random(1,2))
		love.graphics.setLineWidth(1)
		love.graphics.rectangle('fill',self.x +192, self.y +56,4,4)
	end

	if self.tremble then
		love.graphics.pop()
	end
end

function textbox:update( dt )
	if self.follow then
		self.x,self.y = love.mouse.getPosition()
	end
	if type(self.text) == 'table' and self.ready then
		if not self.auto then
			if love.keyboard.isDown('return') then
				if self.place < #self.text then
					self.stageText = self.text[self.place+1]
					self.place = self.place + 1
					self.counter = 1
					self.ready = false
				else
					self.done = true
				end
			end
		else
			if math.floor(self.delayCounter) == self.delay then
				if self.place < #self.text then
					self.stageText = self.text[self.place+1]
					self.place = self.place + 1
					self.counter = 1
					self.ready = false
				else
					self.done = true
				end
				self.delayCounter = 0
			end
		end
	end
	if self.counter < string.len(self.stageText)+1 then
		self.counter = self.counter + .2*self.speed
	end
	self.curText = string.sub(self.stageText,1,math.floor(self.counter))
	if math.floor(self.counter) == string.len(self.stageText)+1 then
		self.ready = true
	end
	if self.auto and self.ready then
		self.delayCounter = self.delayCounter + .1
	end
end