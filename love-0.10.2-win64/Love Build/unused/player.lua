player = {}
function player.create()
  player.img = love.graphics.newImage('succ.jpg')
  
  local x,y = love.graphics.getDimensions()
  x = x/2
  y = y/2
  
  player.shape = love.physics.newCircleShape(24)
  player.body = love.physics.newBody(world,x,y,"kinematic")
  player.fix = love.physics.newFixture(player.body,player.shape,5)
  modifierVelocity = 2.5
end



function player.update(dt)
  local is_down_kb = love.keyboard.isDown
  local x,y = player.body:getPosition()
  if is_down_kb("left") and (x>26) then
      x = x - 100*dt*modifierVelocity
    elseif is_down_kb("right") and (x < love.graphics.getWidth() - 26) then
      x = x + 100*dt*modifierVelocity  -- right
  end
  if is_down_kb("up") and (y>26) then
      y = y - 100--*dt*modifierVelocity
    elseif is_down_kb("down") and (y < love.graphics.getWidth() - 26) then
      y = y + 100*dt*modifierVelocity  -- right
  end
  if is_down_kb("lshift") then
    modifierVelocity = 1.5
  elseif not is_down_kb("lshift") then
    modifierVelocity = 2.5
  end
end
function player.draw()
 -- that mean it's need to move image left to 1/4 width and move down to 1/2 
 -- height. In this way center of human on image will be at center of player 
 -- body. 
 local draw_x, draw_y = player.body:getWorldPoint(-21.25, -26.5)
 -- When drawing angle image like body's angle
 love.graphics.draw(player.img, draw_x, draw_y, player.body:getAngle())
end