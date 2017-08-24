-- assets are still unfinished so all have title.png which says todo

h = 768
w = 1024
require("socket")
gui = require("libraries/gspot")
list = require("libraries/listbox")
binser = require("libraries/binser")
require("mainmenu")
require("libraries/TEsound")
require("libraries/noobhub")
print(socket.gettime())
love.window.setTitle("Bullet Heaven")
-- initial variables
local currentDialogueNumber = 1
local playernum = 1
local bulletSpeed = 5
enemySpeed = 100
local playerSize = 64
local bulletSize = 48
local playerSpeed = 1000
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
    Position = {x = 640, y = 360}
}
highscores = {}
multiplayer_menu = false
menu_dialog = true
game_dialog = false
freemode_menu = false
story_mode_select_menu = false
score_show_dialog = false
group = {}
loadedGroup = 0
-- load story song list
storySongsLoad = love.filesystem.load("assets/groups/storySongs.txt" ) -- load the chunk
result = storySongsLoad() -- execute the chunk

print(group[1].song[1])
print(group[1].dialogs[1][1])
local musicOverlay = {}
local musicBg = {}
local exp = {}
local playerShootBulletOffset = 20
-- defining images and variables for player
local playerImage = love.graphics.newImage("assets/Yotsuba.png")
local playerScale = {x = 1, y = 1}
local playerOffset = {x = playerImage:getWidth()/2,y = playerImage:getHeight()/2}
local transblack = love.graphics.newImage("assets/transparentplayer.png")
-- iamges for boosters
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
quad[0] = love.graphics.newQuad(0,0,128,128,768,128)
quad[1] = love.graphics.newQuad(128,0,128,128,768,128)
quad[2] = love.graphics.newQuad(256,0,128,128,768,128)
quad[3] = love.graphics.newQuad(384,0,128,128,768,128)
quad[4] = love.graphics.newQuad(512,0,128,128,768,128)
quad[5] = love.graphics.newQuad(640,0,128,128,768,128)
-- enemies and such
enemies = {}
--enemy image array
local enemyImage = {}
enemyImage[1] = love.graphics.newImage("assets/enemy1.png")
enemyImage[2] = love.graphics.newImage("assets/enemy1.png")
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
topscore = 0
local playerHealth = 100
local currenttime = ""
score = 0

-- menu
-- functions for Game
function enemyExplode(ei,e)
    local kaboom = {
        x = e.Position.x,
        y = e.Position.y,
        sprite = e.sprite,
        time = socket.gettime()
    }
    table.insert(exp,kaboom)
end
function dialogue(a)
    isDialogue = true
    local addtospeech = {
        text = a,

    }
    table.insert(speech,addtospeech)
end
function addEnemy(xpos,picture,hp,id)
    local enemyAdd = {
        Position = { x = xpos, y = 120},
        health = hp,
        sprite = picture,
        Direction = math.pi/2,
        Type = id,
    }
    table.insert(enemies,enemyAdd)
end
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end
function sectotime(sec)
    local h,m,s=0,0,0
    h=math.floor(sec/3600)%60
    m=math.floor(sec/60)%60
    s=sec%60
    if milliseconds then
        return sec and string.format("%02i:%02i:%.1f",h,m,s) or "00:00:00.0"
    else
        return sec and string.format("%02i:%02i:%02i",h,m,s) or "00:00:00"
    end
end
function enemyShoot(pattern, object, scale)
    if pattern == 1 then -- shoots 3 in /|\
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
    elseif pattern == 10 then -- shoots a circle
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
    elseif pattern == 2 then -- shoots a straight line
        local Bullet = {
            Position = {x = object.Position.x, y = object.Position.y},
            Direction = 0
        }
        table.insert(enemyBullets,Bullet)
    elseif pattern == 3 then -- shoots a flat line -----
        for i = 1, 1*scale do
            local Bullet = {
                Position = {x = object.Position.x + i*2, y = object.Position.y},
                Direction = math.pi/2
            }
            table.insert(enemyBullets,Bullet)
            local Bullet = {
                Position = {x = object.Position.x - i*2, y = object.Position.y},
                Direction = math.pi/2
            }
            table.insert(enemyBullets,Bullet)
        end
    elseif pattern == 4 then --shoots an arc
        for i = 1, 1*scale do
            local Bullet = {
                Position = {x = object.Position.x, y = object.Position.y},
                Direction = math.pi/2 - i*(math.pi/128)
            }
            table.insert(enemyBullets,Bullet)
            local Bullet = {
                Position = {x = object.Position.x, y = object.Position.y},
                Direction = math.pi/2 + i*(math.pi/128)
            }
            table.insert(enemyBullets,Bullet)
        end
    else
        print("No Pattern Specified")
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
state.mainmenu.load()
state.freemode_menu.load()
state.game_play.load()
state.story_mode_select.load()
state.multiplayer.load()
state.multiplayermenu.load()
function love.update(dt)
    TEsound.cleanup()
    if menu_dialog then
        state.mainmenu.update(dt)
    end
    if freemode_song_select_dialog then
        state.freemode_menu.update(dt)
    end
    if story_mode_select_menu then
        state.story_mode_select.update(dt)
    end
    if score_show_dialog then
        state.score_show.update(dt)
    end
    if multiplayer_menu then
        state.multiplayermenu.update(dt)
    end
    if multiplayer_game then
        state.multiplayer.update(dt)
    end
    -- update shooting rate timer
    if game_dialog then
        state.game_play.update(dt)
        bulletTimer = bulletTimer + dt
        spellCardTimer = spellCardTimer + dt
        score = score + dt
        if maps[currentFileNameWoExt].metadata.enemySpeed ~= nil then
            enemySpeed = maps[currentFileNameWoExt].metadata.enemySpeed
        end
        --print(bulletTimer)
        --if not pause_dialog and not menu_dialog and not freemode_song_select_dialog then
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
                playerSpeed = 500
                drawPlayerHitBox = true
                playerShootBulletOffset = 10
            else
				playerSpeed = 1000
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
                    TEsound.play("assets/sfx/ATTACK5.wav",{},0.5)
                    table.insert(bullets,Bullet)
                end
            end
            if love.keyboard.isDown("x") then
                if spellCardTimer > playerSpellCardRate  then
                    TEsound.play("assets/sfx/SPELLCARD.wav",{},1.5)
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
                Position = { x = love.math.random(100,800), y = 50},
                health = 10,
                sprite = 1,
                Direction = math.pi/2,
                Type = 1,
            }
            table.insert(enemies,enemyAdd)
        end
        if love.keyboard.isDown("b") then
            local enemyAdd = {
                Position = { x = love.math.random(99,100), y = 50},
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
            if v.Position.x < -25 or v.Position.x > 1300 or v.Position.y < -25 or v.Position.y > 740 then
                table.remove(enemies,i)
            end
            if v.Position.y < 250 and v.Position.y > 245 and not v.hasPaused and v.Type == 1 or v.Type == 2 then
                v.pause = true
                if not v.pauseTime then v.pauseTime = socket.gettime() end
                if socket.gettime() - v.pauseTime > 3 then v.pause = false v.hasPaused = true end
                if (socket.gettime() - v.pauseTime) > 1.5 and not v.hasFired then
                    v.hasFired = true
                    enemyShoot(1,v)
                end
            end
            if v.hasPaused and v.Type == 1 or v.Type == 2 then
                if v.Type == 1 then
                    if not v.turnTime then v.turnTime = socket.gettime() end
                    if v.Direction ~= math.pi and socket.gettime() > v.turnTime + 0.05 then
                        v.Direction = v.Direction - v.Direction * math.pi/64
                        v.turnTime = socket.gettime()
                    end
                end
                if v.Type == 2 then
                    if not v.turnTime then v.turnTime = socket.gettime() end
                    if v.Direction < (math.pi) and socket.gettime() > v.turnTime + 0.05 then
                        v.Direction = v.Direction + math.pi/64
                        v.turnTime = socket.gettime()
                    end
                end
            end
            if v.Type == 3 then
                if not v.shootTime then v.shootTime = socket.gettime() end
                if socket.gettime() > v.shootTime + 0.3 and not v.hasFired then
                    print("logging")
                    enemyShoot(4,v,10)
                    v.hasFired = true
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
                --[[
                if not b.Dialogue1Complete then
                    isDialogue = true

                    b.Dialogue1Complete = true
                end
                ]]
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
                        enemyExplode(ei,e)
                        table.remove(enemies,ei)
                    end
                    table.remove(bullets,bi)
                    score = score + 1000*math.sqrt((mpos/mduration)*100)
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
                    score = score + 1000*mpos
                end
            end
            --check if out of screen
            if b.Position.x < -25 or b.Position.x > 1300 or b.Position.y < -25 or b.Position.y > 740 then
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
                TEsound.play("assets/sfx/DEAD.wav",{},0.2)
            end
            if b.Position.x < -25 or b.Position.x > 1300 or b.Position.y < -25 or b.Position.y > 740 then
                table.remove(enemyBullets,bi)
            end
        end
        for bi,b in pairs(spellCard) do
            b.Rotation = b.Rotation + dt*2.8
            b.Scale = b.Scale + dt*5.5
            if socket.gettime() > b.spawnTime.time + 2.5 then
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
        state.mainmenu.draw()
    end
    if freemode_menu then
        state.freemode_menu.draw()
    end
    if story_mode_select_menu then
        state.story_mode_select.draw()
    end
    if score_show_dialog then
        state.score_show.draw()
    end
    if multiplayer_menu then
        state.multiplayermenu.draw()
    end
    if multiplayer_game then
        state.multiplayer.draw()
    end
    if game_dialog then
        state.game_play.draw()
        love.graphics.setColor(255, 255, 255, 192)
        love.graphics.draw(bg,(player.Position.x+640)/8,(player.Position.y+360)/8,0,1,1,bg:getWidth()/2,bg:getHeight()/2)
        ----------------- doesnt work ?????

        love.graphics.draw(playerImage,player.Position.x,player.Position.y,0,playerScale.x,playerScale.y,playerOffset.x,playerOffset.y)
        for i,v in pairs(exp) do
            cur = round ( (socket.gettime() - v.time) * 10 )
            if cur > 5 then
                cur = 5
                table.remove(exp,i)
            end
            love.graphics.draw(explosion,quad[cur],v.x,v.y,0,v.sprite,v.sprite,64,64)
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
        if drawPlayerHitBox then
            love.graphics.draw(playerHitBoxImage,player.Position.x,player.Position.y,0,0.1,0.1,50,50)
        end
        if isDialogue then
            love.graphics.draw(transblack, 50, 768-200, 0, 18, 3, 0, 0, -0.02, 0)
            love.graphics.printf(speech[currentDialogueNumber].text, 60, 768-180, 16*50, "left", 0)
        end
        -- UI ELEMENTS, DRAWN ON TOP OF all
        function drawGameUI()
            ffont = "assets/AlteHaasGroteskRegular.ttf"
            ffontbold = "assets/AlteHaasGroteskBold.ttf"
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle( "fill", 0, 0, 1280, 120)
            --scorez
            love.graphics.setColor(255,255,255)
            love.graphics.setNewFont(ffontbold, 20)
            love.graphics.print("Highscore: ".. topscore ,20, 20, 0, 1, 1)
            love.graphics.setNewFont(ffont, 25)
            love.graphics.print(round(score,0), 20, 40)
            --song and difficulty
            love.graphics.setNewFont(ffont, 20)
            love.graphics.print("Song\n"..maps[currentFileNameWoExt].metadata.artist.."\n"..currentFileNameWoExt, 400, 20)
            love.graphics.print("BPM\n"..maps[currentFileNameWoExt].metadata.BPM, 700, 20)
            love.graphics.print("Length\n"..sectotime(mpos).."\n"..sectotime(mduration),800,20)
            if score > topscore then topscore = round(score) end
        end
        drawGameUI()
    end
end
