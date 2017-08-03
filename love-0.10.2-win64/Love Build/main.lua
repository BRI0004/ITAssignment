-- assets are still unfinished so all have title.png which says todo

h = 768
w = 1024
require("socket")
require("boringmainmenustuff")
gui = require("inappropriateName")
print(socket.gettime())
love.window.setTitle("Bullet Heaven")
-- initial variables
local currentDialogueNumber = 1
local playernum = 1
local bulletSpeed = 5
local enemySpeed = 100
local playerSize = 64
local bulletSize = 48
local playerSpeed = 300
local playerShootRate = 0.05
local playerSpellCardRate = 10
local spellCardTimer = 10
local speakRate = 3
local speechRate = 0
local playerFlashTime = 0.5
local playerIsShow = true
isDialogue = false
globalTimer = 0
local drawPlayerHitBox = false
math.randomseed(os.time())
local player = {
    Position = {x = 300, y = 300}
}

local menu_dialog = true
local game_dialog = false



local exp = {}
local playerShootBulletOffset = 20
-- defining images and variables for player
local titleImage = love.graphics.newImage("assets/title.png")
local playerImage = love.graphics.newImage("assets/player.png")
local playerScale = {x = 1, y = 1}
local playerOffset = {x = playerImage:getWidth()/2,y = playerImage:getHeight()/2}
local transblack = love.graphics.newImage("assets/transparentplayer.png")
-- iamges for boosters
local scoreImage = love.graphics.newImage("assets/title.png")
local powerImage = love.graphics.newImage("assets/title.png")
local bossHealthBar = love.graphics.newImage("assets/healthBar.png")
-- images for bullets
local enemyBullets = {}
local bullets = {}
local spells = {}
local boss = {}
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
local explosion = love.graphics.newImage("assets/explosion.png")
-- quad for explisions
quad = {}
quad[0] = love.graphics.newQuad(0,0,64,64,256,256)
quad[1] = love.graphics.newQuad(64,0,64,64,256,256)
quad[2] = love.graphics.newQuad(128,0,64,64,256,256)
quad[3] = love.graphics.newQuad(192,0,64,64,256,256)

quad[4] = love.graphics.newQuad(0,64,64,64,256,256)
quad[5] = love.graphics.newQuad(64,64,64,64,256,256)
quad[6] = love.graphics.newQuad(128,64,64,64,256,256)
quad[7] = love.graphics.newQuad(192,64,64,64,256,256)

quad[8] = love.graphics.newQuad(0,128,64,64,256,256)
quad[9] = love.graphics.newQuad(64,128,64,64,256,256)
quad[10] = love.graphics.newQuad(128,128,64,64,256,256)
quad[11] = love.graphics.newQuad(192,128,64,64,256,256)

quad[12] = love.graphics.newQuad(0,192,64,64,256,256)
quad[13] = love.graphics.newQuad(64,192,64,64,256,256)
quad[14] = love.graphics.newQuad(128,192,64,64,256,256)
quad[15] = love.graphics.newQuad(192,192,64,64,256,256)
-- enemies and such
local enemies = {}
--enemy image array
local enemyImage = {}
enemyImage[1] = love.graphics.newImage("assets/enemy1.png")
enemyImage[2] = love.graphics.newImage("assets/title.png")
enemyImage[10] = love.graphics.newImage("assets/boss1.png")
-- .... for more enemies
local enemyScale = {x = 0.5, y = 0.5}
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
local currenttime = ""
local score = 0
-- functions for Game
function dialogue(a)
    local addtospeech = {
        text = a,

    }
    table.insert(speech,addtospeech)
end
function addEnemy(xpos,rof,time,sprite,hp)
    local enemy = {
        Position = {x = xpos},
        rateOfFire = rof,
        spawnTime = time,
        Image = sprite,
        health = hp,
        isSpawned = false
    }
    table.insert(enemies,enemy)
end
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end
function SecondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end
function enemyShoot(pattern, object)
    if pattern == 1 then
        for i = 1, 3, 1 do
            angle = 0
            if i == 1 then angle = (7.5*math.pi)/6 end
            if i == 2 then angle = (3*math.pi)/2 end
            if i == 3 then angle = (10.5*math.pi)*6 end
            local Bullet = {
                Position = {x = object.Position.x, y = object.Position.y},
                Direction = angle + math.pi+(math.pi/4)
            }
            table.insert(enemyBullets,Bullet)
        end
    end
    if pattern == 10 then
        print("logging")
        angle = 0
        for j = 1, 1 do
            angle = angle + j*10
            for i = 1, 32 do
                local Bullet = {
                    Position = {x = object.Position.x, y = object.Position.y},
                    Direction = angle + i*(math.pi/16)
                }
                table.insert(enemyBullets,Bullet)
            end
        end
    end
end
--enemyShoot(10,player)
local bg = love.graphics.newImage("assets/bg.png")

-----------------------------------------------
function love.keypressed(key)
    if key == "escape" then
            menu_dialog = false
            game_dialog = true
            isDialogue = true

    elseif key == "y" then
        love.event.quit()
    elseif key == "n" then
        pause_dialog = false
    end
end

loadthestuff()

function love.update(dt)
    if menu_dialog then

    end
    if song_select_dialog then

    end
    -- update shooting rate timer
    if game_dialog then
        currenttime = SecondsToClock(dt)
        bulletTimer = bulletTimer + dt
        spellCardTimer = spellCardTimer + dt
        score = score + dt
        --print(bulletTimer)
        --if not pause_dialog and not menu_dialog and not song_select_dialog then
        -- make player move
        if not isDialogue then
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
                playerShootBulletOffset = 10
            else
                playerSpeed = 300
                drawPlayerHitBox = false
                playerShootBulletOffset = 25
            end

            if love.keyboard.isDown("z") then
                if bulletTimer > playerShootRate then
                    bulletTimer = 0
                    local Bullet = {
                        Position = {x = player.Position.x-playerShootBulletOffset, y = player.Position.y - 15}
                    }
                    table.insert(bullets,Bullet)
                    local Bullet = {
                        Position = {x = player.Position.x+playerShootBulletOffset, y = player.Position.y - 15}
                    }
                    table.insert(bullets,Bullet)
                end
            end
            if love.keyboard.isDown("x") then
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
        end
        if love.keyboard.isDown("c") then
                isDialogue = true
        if menu_dialog then
            menu_dialog = false
            game_dialog = true
        end

        end
        if love.keyboard.isDown("v") then
            local enemyAdd = {
                Position = { x = love.math.random(100,800), y = 200},
                health = 10,
                sprite = 1,
                Direction = math.pi/2,
                Type = 1,
            }
            table.insert(enemies,enemyAdd)
        end
        if love.keyboard.isDown("b") then
            local enemyAdd = {
                Position = { x = love.math.random(100,800), y = 200},
                health = 10,
                sprite = 1,
                Direction = math.pi/2,
                Type = 2,
            }
            table.insert(enemies,enemyAdd)
        end
        if love.keyboard.isDown("n") then
            if not bossTimer then bossTimer = socket.gettime() end
            if bossTimer + 3 < socket.gettime() then
                local bossAdd = {
                    Position = { x = love.math.random(100,800), y = 100},
                    health = 1000,
                    sprite = 10,
                    Direction = math.pi/2,
                    Type = 1,
                }
                table.insert(boss,bossAdd)
                bossTimer = socket.gettime()
            end
        end
        --------------------------------------------------------------------------

        -- making bullets move and checking if enemy collision using simple detection
        for i, v in pairs(enemies) do
            if not v.pause then
                v.Position.y = v.Position.y + (math.sin(v.Direction)*dt*enemySpeed)
                v.Position.x = v.Position.x + (math.cos(v.Direction)*dt*enemySpeed)
            end
            if v.Position.x < 0 or v.Position.x > 1024 or v.Position.y < 5 or v.Position.y > 768 then
                table.remove(enemies,i)
            end
            if v.Position.y < 250 and v.Position.y > 245 and not v.hasPaused then
                v.pause = true
                if not v.pauseTime then v.pauseTime = socket.gettime() end
                if socket.gettime() - v.pauseTime > 3 then v.pause = false v.hasPaused = true end
                if (socket.gettime() - v.pauseTime) > 1.5 and not v.hasFired then
                    v.hasFired = true
                    enemyShoot(1,v)
                end
            end
            if v.hasPaused and v.Type == 1 then
                if not v.turnTime then v.turnTime = socket.gettime() end

                if v.Direction ~= math.pi and socket.gettime() > v.turnTime + 0.05 then
                    v.Direction = v.Direction - v.Direction * math.pi/64
                    v.turnTime = socket.gettime()
                end
            end
            if v.hasPaused and v.Type == 2 then
                if not v.turnTime then v.turnTime = socket.gettime() end
                if v.Direction < (math.pi) and socket.gettime() > v.turnTime + 0.05 then
                    v.Direction = v.Direction + math.pi/64
                    v.turnTime = socket.gettime()
                end
            end
        end
        for bi,b in pairs(boss) do
            if not b.pause then
                b.Position.y = b.Position.y + (math.sin(b.Direction)*dt*enemySpeed)
                b.Position.x = b.Position.x + (math.cos(b.Direction)*dt*enemySpeed)
            end
            if b.health < 0 then
                b.health = 0
                table.remove(boss,bi)
            end
            if b.Type == 1 then
                if not b.Dialogue1Complete then
                    isDialogue = true
                    dialogue("...: 'Hello Yotsuba'")
                    dialogue("...: 'My name is steve and you are an intruder to our world'")
                    dialogue("steve: 'I need to stop you before you realise who you are'")
                    dialogue("Yotsuba: 'I...I don't understand!?'")
                    dialogue("steve: ''")
                    b.Dialogue1Complete = true
                end
                if b.Position.y < 305 and b.Position.y > 300 and not b.hasPaused1 then
                    b.pause = true
                    if not b.pauseTime then b.pauseTime = socket.gettime() end
                    if socket.gettime() - b.pauseTime > 3 and not isDialogue then b.hasPaused1 = true end
                    if (socket.gettime() - b.pauseTime) > 1.5 and not b.hasFired1 and not isDialogue then
                        b.hasFired1 = true
                        enemyShoot(10,b)
                    end
                end
            end
        end
        for bi,b in pairs(bullets) do
            b.Position.y = b.Position.y - 250*dt*bulletSpeed
            for ei,e in pairs(enemies) do
                distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
                if distance < ((enemySize[e.sprite]/2+bulletSize/2)*enemyScale.x) then
                    e.health = e.health - 5
                    if e.health < 0 then
                        e.health = 0
                        table.remove(enemies,ei)
                    end
                    table.remove(bullets,bi)
                    score = score + 100
                end
            end
            for ei,e in pairs(boss) do
                distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
                if distance < ((50+bulletSize/2)*0.3) then
                    e.health = e.health - 5
                    if e.health < 0 then
                        e.health = 0
                        table.remove(boss,ei)
                        love.event.quit()
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
        for bi,b in pairs(enemyBullets) do
            local bulletSpeedMod = 50
            b.Position.y = b.Position.y + (math.sin(b.Direction)*dt*bulletSpeed*bulletSpeedMod)
            b.Position.x = b.Position.x + (math.cos(b.Direction)*dt*bulletSpeed*bulletSpeedMod)
            local distance = ((player.Position.x-b.Position.x)^2+(player.Position.y-b.Position.y)^2)^0.5
            if distance < 10 then
                print("ded")
            end
            if b.Position.x < 0 or b.Position.x > 1024 or b.Position.y < 5 or b.Position.y > 768 then
                table.remove(enemyBullets,bi)
            end
        end
        for bi,b in pairs(spellCard) do
            b.Rotation = b.Rotation + dt*1.5
            b.Scale = b.Scale + dt*1.2
            if socket.gettime() > b.spawnTime.time + 5 then
                table.remove(spellCard,1)
            end
            for ei,e in pairs(enemies) do
                distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
                if distance < ((enemySize[e.sprite]/2+(b.Scale*50))*enemyScale.x)*1.3 then
                    e.health = e.health - 10
                    if e.health < 0 then
                        e.health = 0
                        table.remove(enemies,ei)
                    end
                    score = score + 100
                end
            end
            for ei,e in pairs(enemyBullets) do
                distance = ((e.Position.x-b.Position.x)^2+(e.Position.y-b.Position.y)^2)^0.5
                if distance < ((bulletSize/2+(b.Scale*50))) then
                    table.remove(enemyBullets, ei)
                end
            end
        end
        if isDialogue then
            if not keyTimer then keyTimer = socket.gettime() end
            if love.keyboard.isDown("z") and keyTimer + 0.2 < socket.gettime() then
                currentDialogueNumber = currentDialogueNumber + 1
                keyTimer = socket.gettime()
            end
            speechRate = speechRate + dt
            if speechRate > speakRate then
                speechRate = 0
                currentDialogueNumber = currentDialogueNumber + 1
            end
            if currentDialogueNumber > #speech then
                isDialogue = false
            end
        end
    end
end
function love.draw()
    if menu_dialog then
        drawmainmenutext()

    end
    if song_select_dialog then

    end

    if game_dialog then
        love.graphics.setColor(255, 255, 255, 192)
        love.graphics.draw(bg,(player.Position.x+300)/4,(player.Position.y+400)/4,0,1,1,bg:getWidth()/2,bg:getHeight()/2)
        ----------------- doesnt work ?????

        love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
        for i,v in pairs(exp) do
            cur = round ( (socket.gettime() - v.time) * 10 )
            if cur > 15 then
                cur = 15
                table.remove(exp,i)
            end
            love.graphics.draw(explosion,quad[cur],v.x,v.y,0,v.sprite*.5,v.sprite*.5,32,32)
        end
        for i,v in pairs(bullets) do
            love.graphics.draw(playerBullets[0],v.Position.x,v.Position.y,v.Direction,0.2,0.2,50,50)
        end
        for i, v in pairs(spellCard) do
            love.graphics.draw(spells[0],v.Position.x,v.Position.y,v.Rotation,v.Scale,v.Scale,50,50)
        end
        for i, v in pairs(enemies) do
            love.graphics.draw(enemyImage[v.sprite],v.Position.x,v.Position.y,0,enemyScale.x,enemyScale.y,enemyOffset[v.sprite].x,enemyOffset[v.sprite].y)
        end
        for i, v in pairs(enemyBullets) do
            love.graphics.draw(playerBullets[3],v.Position.x,v.Position.y,v.Direction,0.2,0.2,50,50)
        end
        for i, v in pairs(boss) do
            love.graphics.draw(enemyImage[v.sprite],v.Position.x,v.Position.y,v.Direction,0.3,0.3,50,50)
            love.graphics.draw(bossHealthBar, 10, 150, 0, boss[1].health/100, 0.2)
        end
        --love.graphics.draw(bg,player.Position.x/4-300,player.Position.y/4-400,0,4,4,0,0)
        --love.graphics.draw(bg,player.Position.x/2-600,player.Position.y/2-200,0,4,4,0,0)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
        if drawPlayerHitBox then
            love.graphics.draw(playerHitBoxImage,player.Position.x,player.Position.y,0,0.1,0.1,50,50)
        end
        if isDialogue then
            love.graphics.draw(transblack, 50, 768-200, 0, 18, 3, 0, 0, -0.02, 0)
            love.graphics.printf(speech[currentDialogueNumber].text, 60, 768-180, 16*50, "left", 0)
        end
        -- UI ELEMENTS, DRAWN ON TOP OF all
        function drawGameUI()
            fmr = "assets/AlteHaasGroteskRegular.ttf"
            love.graphics.draw(playerImage,0,0,0,21,3,0,0)
            --scorez
            love.graphics.setNewFont(fmr, 20)
            love.graphics.print("Score: ".. topscore ,20, 20, 0, 1, 1)
            love.graphics.setNewFont(fmr, 25)
            love.graphics.print(round(score,0), 20, 40)
            --song and difficulty
            love.graphics.setNewFont(fmr, 20)
            love.graphics.print("Song\nZUN\nUN Owen Was Her", 200, 20)
            love.graphics.print("BPM\n152", 300, 20)
            love.graphics.print("Length",450,20)
            love.graphics.print("\n"..currenttime,450,20)
            love.graphics.print("\n\n00:04:18",450,20)
        end
        drawGameUI()
    end
end
dialogue("Yotsuba awakes from the ruins.")
dialogue("She sees a large enemy in the corner of her eye.")
dialogue("Yotsuba: 'owo what's this?'")
dialogue("Yotsuba : '...Why can I shoot bullets with my arm?'")
