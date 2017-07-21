h = 768
w = 1024
love.window.setTitle("traps arent gay")
require("player")

local playernum = 1
local bulletSpeed = 500
local enemySpeed = 100
local playerSize = 64
local bulletSize = 48

math.randomseed(os.time())
local player = {
 Position = {x = 100, y = 100} 
  
}
local titleImage = love.graphics.newImage("assets/title.png")
local playerImage = love.graphics.newImage("assets/title.png")
local playerScale = {x = 1, y = 1}
local playerOffset = {x = playerImage:getWidth()/2,y = playerImage:getHeight()/2}

function love.load()
  
  world = love.physics.newWorld(0, 0, true)
  player.create()
end

function love.update(dt)
  world:update(dt)
  player.update(dt)
end

function love.draw()
 player.draw()
end