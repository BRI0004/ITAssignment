-- assets are still unfinished so all have title.png which says todo

h = 768
w = 1024
love.window.setTitle("traps arent gay")
require("player")
-- initial variables
local playernum = 1
local bulletSpeed = 500
local enemySpeed = 100
local playerSize = 64
local bulletSize = 48

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
local playerBulletQuad = {}
-- offset x by 48 each quad
playerBulletQuad[0] = love.graphics.newQuad(0,0,48,48,240,48)
playerBulletQuad[1] = love.graphics.newQuad(48,0,48,48,240,48)
playerBulletQuad[2] = love.graphics.newQuad(96,0,48,48,240,48)
playerBulletQuad[3] = love.graphics.newQuad(144,0,48,48,240,48)
playerBulletQuad[4] = love.graphics.newQuad(192,0,48,48,240,48)
playerBulletQuad[5] = love.graphics.newQuad(240,0,48,48,240,48)
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



function love.load()
end

function love.update(dt)
end

function love.draw()
end