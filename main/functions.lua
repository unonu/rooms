function getCentreScreen(xory)
	if xory then
		if xory == 'x' then
			return (love.graphics.getWidth()/2)
		elseif xory == 'y' then
			return (love.graphics.getHeight()/2)
		end
	else
		local result = {love.graphics.getWidth()/2, love.graphics.getHeight()/2}
		return result
	end
end

function loadFonts()
	local fonts = {}
	local numFonts = 0
	local files = love.filesystem.enumerate('fonts/')
	for i, f in ipairs(files) do
		if string.sub(f,-4) == '.png' then
			local fontDef = love.filesystem.read('fonts/'..string.sub(f,1,-4)..'font')
			print('found '..f..'\n'..fontDef)
			fonts[string.sub(f,1,-5)] = love.graphics.newImageFont('fonts/'..f,fontDef)
			numFonts = numFonts + 1
		end
	end
	
	print(numFonts..' fonts found')
	return fonts
end
