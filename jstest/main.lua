function love.load()
   joystick = love.joystick.getJoysticks()[1]

   if joystick:isGamepad() == true then
      print("joystick 1 \"" .. joystick:getName() .. "\" is a gamepad")
   end
   _, abutton = joystick:getGamepadMapping("a")
   print("A button is " .. abutton)
end

function love.update(dt)
   if joystick:isGamepadDown("a") then
      print("isGamepadDown(a) == true")
   end
   if joystick:isDown(abutton) then
      print("isDown(a) == true")
   end
end
