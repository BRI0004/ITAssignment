-- assets are still unfinished so all have title.png which says todo

h = 768
w = 1024
require("socket")
print(socket.gettime())
love.window.setTitle("blyat")
-- initial variables
local playernum = 1
local bulletSpeed = 5
local enemySpeed = 100
local playerSize = 64
local bulletSize = 48
local playerSpeed = 300
local playerShootRate = 0.1
local playerSpellCardRate = 10
local spellCardTimer = 10
song_select_dialog = not song_select_dialog
menu_dialog = not menu_dialog
local drawPlayerHitBox = false
math.randomseed(os.time())
local player = {
 Position = {x = 200, y = 500}
}
-- defining images and variables for player
local titleImage = love.graphics.newImage("assets/title.png")
local playerImage = love.graphics.newImage("assets/player.png")
local playerScale = {x = 1, y = 1}
local playerOffset = {x = playerImage:getWidth()/2,y = playerImage:getHeight()/2}
local transblack = love.graphics.newImage("assets/transparentplayer.png")
-- iamges for boosters
local scoreImage = love.graphics.newImage("assets/title.png")
local powerImage = love.graphics.newImage("assets/title.png")

-- images for bullets
local bullets = {}
local spells = {}
spells[0] = love.graphics.newImage("assets/spell1.png")
local playerBullets = {}
-- offset x by 48 each quad
playerBullets[0] = love.graphics.newImage("assets/bulletBlue.png")
playerBullets[1] = love.graphics.newImage("assets/bulletGreen.png")
playerBullets[2] = love.graphics.newImage("assets/bulletPink.png")
playerBullets[3] = love.graphics.newImage("assets/bulletRed.png")
playerBullets[4] = love.graphics.newImage("assets/bulletBlack.png")
playerBullets[5] = love.graphics.newImage("assets/bulletBlue.png")
-- playerbullet variables
local bulletScale = 0.05
local bulletOffset = 50
local bulletTimer = 0
local playerHitBoxImage = playerBullets[3]

local spellCard = {}

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
local speech = {}
-- timer for enemies
local enemyTimer = 0
local topscore = 0
local playerHealth = 100

local score = 0
-- functions for Game
function dialogue(a)
    local addtospeech = {
        text = a
    }
    table.insert(speech,addtospeech)
end
function addEnemy(xpos,rof,time,sprite,hp)
    local enemy = {
        Position = {x = xpos},
        rateOfFire = rof,
        spawnTime = time,
        Image = sprite,
        Health = hp,
        isSpawned = false
    }
    table.insert(enemies,enemy)
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local bg = love.graphics.newImage("assets/bg.png")

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
    print(#spellCard)
  -- update shooting rate timer
  bulletTimer = bulletTimer + dt
  spellCardTimer = spellCardTimer + dt
  score = score + dt
  --print(bulletTimer)
  --if not pause_dialog and not menu_dialog and not song_select_dialog then
  -- make player move
    if love.keyboard.isDown("up") and player.Position.y > 0 then
      player.Position.y = player.Position.y - playerSpeed * dt
    end
    if love.keyboard.isDown("down") and player.Position.y < 768 then
      player.Position.y = player.Position.y + playerSpeed * dt
    end
    if love.keyboard.isDown("left") and player.Position.x > 0 then
      player.Position.x = player.Position.x - playerSpeed * dt
    end
    if love.keyboard.isDown("right") and  player.Position.y < 1024 then
      player.Position.x = player.Position.x + playerSpeed * dt
    end
    if love.keyboard.isDown("lshift") then
      playerSpeed = 150
      drawPlayerHitBox = true
    else
      playerSpeed = 300
      drawPlayerHitBox = false
    end
    if love.keyboard.isDown("z") then
      if bulletTimer > playerShootRate then
        bulletTimer = 0
        local Bullet = {
          Position = {x = player.Position.x, y = player.Position.y}
        }
        table.insert(bullets,Bullet)
      end
    end
    if love.keyboard.isDown("x") then
        dialogue("jlsadfnj  sda sadasdf dafs dsaffasdf asdf sadf  nannaianiani aninasdiofnaios dnfaosdjfioajsdi ofjasdiofjai sodjfioasdjfioa sjdfioajsdiofj asdiofjaiosdjfio asdjfioasdjf oijsdoiajfi oasjd")
      if spellCardTimer > playerSpellCardRate  then
          spellCardTimer = 0
          local spellcard = {
              Position = {x = player.Position.x, y = player.Position.y},
              Rotation = 0,
              Scale = 0.5,
              spawnTime = {time = socket.gettime()}
          }
          table.insert(spellCard,spellcard)
      end
    end
--------------------------------------------------------------------------

-- making bullets move and checking if enemy collision using simple detection
for bi,b in pairs(bullets) do
  b.Position.y = b.Position.y - b.Position.y*dt*bulletSpeed
  for ei,e in pairs(enemies) do
    distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
    if distance < ((enemySize[e.sprite]/2+bulletSize/2)*enemyScale.x) then
      e.health = e.health - 5
      if e.health < 0 then
        e.health = 0
      end
      table.remove(bullets,bi)
      score = score + 100
    end
  end
  --check if out of screen
  if b.Position.x < 0 or b.Position.x > 1024 or b.Position.y < 5 or b.Position.y > 768 then
    table.remove(bullets,bi)
  end
end
for bi,b in pairs(spellCard) do
    b.Rotation = b.Rotation + dt*1.5
    b.Scale = b.Scale + dt*1.2
    print(b.Rotation)
    if socket.gettime() > b.spawnTime.time + 5 then
        print(b)
        print(bi)
        table.remove(spellCard,1)
    end
end

end
function love.load()
end

function love.draw()

  love.graphics.setColor(255, 255, 255, 192)
  love.graphics.draw(bg,player.Position.x/8-600,player.Position.y/8-600,0,4,4,0,0)
  love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
  for i,v in pairs(bullets) do
      love.graphics.draw(playerBullets[0],v.Position.x,v.Position.y,v.Direction,0.3,0.3,50,50)
  end
  for i, v in pairs(spellCard) do
      love.graphics.draw(spells[0],v.Position.x,v.Position.y,v.Rotation,v.Scale,v.Scale,50,50)
  end
  --love.graphics.draw(bg,player.Position.x/4-300,player.Position.y/4-400,0,4,4,0,0)
  --love.graphics.draw(bg,player.Position.x/2-600,player.Position.y/2-200,0,4,4,0,0)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
  if drawPlayerHitBox then
    love.graphics.draw(playerHitBoxImage,player.Position.x,player.Position.y,0,0.1,0.1,50,50)
  end
  if speech then
      for i,v in pairs(speech) do
          love.graphics.draw(transblack, 50, 768-200, 0, 18, 3, 0, 0, -0.02, 0)
          local time1 = socket.gettime() + 5
          love.graphics.printf(v.text, 60, 768-180, 16*50, "left", 0)
          if time1 < socket.gettime() then
              table.remove(v)
              speech = nil
          end
      end
  end
  -- UI ELEMENTS, DRAWN ON TOP OF all
  function drawGameUI()
    fmr = "assets/fmr.ttf"
    love.graphics.draw(playerImage,0,0,0,21,3,0,0)
    --score
    love.graphics.setNewFont(fmr, 20)
    love.graphics.print("Score: ".. topscore ,20, 20, 0, 1, 1)
    love.graphics.setNewFont(fmr, 25)
    love.graphics.print(round(score,5), 20, 40)
    --song and difficulty
    love.graphics.setNewFont(fmr, 20)
    love.graphics.print("Song\ntest\ntest", 200, 20)
    love.graphics.print("BPM\nbpmdesu", 300, 20)
    love.graphics.print("Length\n1:23\n2:34",450,20)
     end
  drawGameUI()
end
