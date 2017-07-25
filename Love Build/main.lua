-- assets are still unfinished so all have title.png which says todo

h = 768
w = 1024
require("socket")
print(socket.gettime())
love.window.setTitle("blyat")
-- initial variables
local playernum = 1
local bulletSpeed = 100
local enemySpeed = 100
local playerSize = 64
local bulletSize = 48
local playerSpeed = 100
local playerShootRate = 0.10
song_select_dialog = not song_select_dialog
menu_dialog = not menu_dialog
math.randomseed(os.time())
local player = {
 Position = {x = 100, y = 100}
}
-- defining images and variables for player
local titleImage = love.graphics.newImage("assets/title.png")
local playerImage = love.graphics.newImage("assets/title.png")
local playerScale = {x = 1, y = 1}
local playerOffset = {x = playerImage:getWidth()/2,y = playerImage:getHeight()/2}

-- iamges for boosters
local scoreImage = love.graphics.newImage("assets/title.png")
local powerImage = love.graphics.newImage("assets/title.png")

-- images for bullets
local bullets = {}
local playerBullets = {}
-- offset x by 48 each quad
playerBullets[0] = love.graphics.newImage("assets/bulletBlue.png")
playerBullets[1] = love.graphics.newQuad(48,0,48,48,240,48)
playerBullets[2] = love.graphics.newQuad(96,0,48,48,240,48)
playerBullets[3] = love.graphics.newQuad(144,0,48,48,240,48)
playerBullets[4] = love.graphics.newQuad(192,0,48,48,240,48)
playerBullets[5] = love.graphics.newQuad(240,0,48,48,240,48)
-- playerbullet variables
local bulletScale = 1
local bulletOffset = 24
local bulletTimer = 0

-- enemies and such
local enemies = {}
--enemy image array
local enemyImage = {}
enemyImage[1] = love.graphics.newImage("assets/title.png")
enemyImage[2] = love.graphics.newImage("assets/title.png")
-- .... for more enemies
local enemyScale = {x = 1, y = 1}
-- setting offsets and size for each image
local enemyOffset = {}
local enemySize = {}
for i = 1, #enemyImage,1 do
  enemyOffset[i] = {x = enemyImage[i]:getWidth()/2,y = enemyImage[i]:getHeight()/2}
  enemySize[i] = enemyImage[i]:getHeight()
end

-- timer for enemies
local enemyTimer = 0
local topscore = 0
local playerHealth = 100

local score = 0
<<<<<<< HEAD
local bg = love.graphics.newImage("assets/title.png")
-- functions for Game
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

=======
local bg = love.graphics.newImage("assets/bg.png")
>>>>>>> 8f26906fdb71403bc5a0d24e96560a805fcf0c18

-----------------------------------------------
function love.keypressed(key)
  print(key)
  if key == "escape" then
      pause_dialog = not pause_dialog
    elseif key == "y" then
      love.event.quit()
    elseif key == "n" then
      pause_dialog = false
  end
end


function love.update(dt)
  print(#bullets)
  -- update shooting rate timer
  bulletTimer = bulletTimer + dt
  print(bulletTimer)
  --if not pause_dialog and not menu_dialog and not song_select_dialog then
  -- make player move
    if love.keyboard.isDown("up") then
      player.Position.y = player.Position.y - playerSpeed * dt
    end
    if love.keyboard.isDown("down") then
      player.Position.y = player.Position.y + playerSpeed * dt
    end
    if love.keyboard.isDown("left") then
      player.Position.x = player.Position.x - playerSpeed * dt
    end
    if love.keyboard.isDown("right") then
      player.Position.x = player.Position.x + playerSpeed * dt
    end
    if love.keyboard.isDown("lshift") then
      playerSpeed = 50
    else
      playerSpeed = 100
    end
<<<<<<< HEAD
    if love.keyboard.isDown("z") then
      if bulletTimer > playerShootRate then
        bulletTimer = 0
        local Bullet = {
          Position = {x = player.Position.x, y = player.Position.y},
        }
        table.insert(bullets,Bullet)
      end
    end
--------------------------------------------------------------------------

-- making bullets move and checking if enemy collision using simple detection
for bi,b in pairs(bullets) do
      b.Position.y = b.Position.y +b.Position.y*dt*bulletSpeed
      for ei,e in pairs(enemies) do
        distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
        if distance < ((enemySize[e.sprite]/2+bulletSize/2)*enemyScale.x) then
          e.health = e.health - 5
          if e.health < 0 then
            e.health = 0
          end
          table.remove(bullets,bi)
          score = score + 100
          enemyRate = enemyRate - 0.0002
          enemySpeed = enemySpeed + 0.01
        end
      end
      --check if out of screen
      if b.Position.x < 0 or b.Position.x > 600 or b.Position.y < 0 or b.Position.y > 600 then
        table.remove(bullets,bi)
      end
    end
=======
    
>>>>>>> 8f26906fdb71403bc5a0d24e96560a805fcf0c18
end
function love.load()
end

function love.draw()
<<<<<<< HEAD
  --[[
    pause_dialog = false
=======
    --[[
  pause_dialog = false
>>>>>>> 8f26906fdb71403bc5a0d24e96560a805fcf0c18
  if pause_dialog then
    -- draw pause screen
    love.graphics.setColor(255, 255, 255, math.random(64,192))
    love.graphics.draw(titleImage,math.random(-5,5),math.random(-5,5)+200,0,1,1)
    love.graphics.draw(TitleImage,0,200,0,1,1)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Game Paused. Are you sure you want to quit? (y/n)', 200, 300)
  elseif menu_dialog then
    --------
  elseif song_select_dialog then
  --------
  else
    ]]
  love.graphics.setColor(255, 255, 255, 192)
  love.graphics.draw(bg,player.Position.x/8-600,player.Position.y/8-600,0,4,4,0,0)
<<<<<<< HEAD
  ]]
  love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
  for i,v in pairs(bullets) do
      cur = (round(socket.gettime() * 10) + i) % 5
      curimage = MissileImage
      love.graphics.draw(curimage,bulletquad[cur],v.Position.x,v.Position.y,v.Direction,BulletScale,BulletScale,BulletOffset,BulletOffset)
    end
=======
  love.graphics.draw(bg,player.Position.x/4-300,player.Position.y/4-400,0,4,4,0,0)
  love.graphics.draw(bg,player.Position.x/2-600,player.Position.y/2-200,0,4,4,0,0)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
>>>>>>> 8f26906fdb71403bc5a0d24e96560a805fcf0c18
end
