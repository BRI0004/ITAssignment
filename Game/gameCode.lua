player = display.newRect(w/2,h,w/50,h/10)
physics.addBody(player,"kinematic",{friction=0.0, bounce=0.0, density=0.0, radius=player.contentWidth/2.0, filter=collisionFilterPlayer})
player:setFillColor(1,1,1)
player.movementSpeed = 10
player.movementSpeedModifer = 1
player.powerlevel = 1
player.selectedSpellCard = 1
player.spellCardInProgress = 0
player.myName = "player object"

playerHitBox = display.newImageRect('danmaku1.png',w/30,w/30)
playerHitBox:setFillColor(1,0.5,0.5)


--function to create amount of maku inside a table
--table to be used for hit detection and shiizz
-- a is amount b is table
createMakuInTable = function (a)
	b = {}
	for i=1,a,1 do
		b[i] = display.newImageRect('danmaku1.png',w/30,w/30)
		physics.addBody(b[i], "kinematic",{friction=0.0, bounce=0.0, density=0.0, radius=b[i].contentWidth/2.0,})
		b[i].isBullet = true
		b[i].myName = "enemy bullet"
		removeSelfOnDelay(b[i])
	end
	return b
end





--create circle of radius x with all maku in a table
-- r is radius b is table
--cx is origin x and cy origin y
circleMaku = function (r,b,cx,cy)
	--find degree seperatin
	local a = (360 / #b)*(math.pi/180)
	--print(a)
	for i=1,#b,1 do
		b[i].dx = math.cos(a * i)
		b[i].dy = math.sin(a * i)
		b[i].x = cx + r * b[i].dx
		b[i].y = cy + r * b[i].dy
        b[i].velocity = 1
	end
	return b
end






function playerSpellCard()
	if (player.selectedSpellCard == 1) then
		player.spellCardInProgress = 1
		if playerSpellCardObjects == nil then
			playerSpellCardObjects = {}
		end
			-- player spell card 1, rotating boxes that remove any danmaku
			playerSpellCardObjects[1] = display.newRect(player.x, player.y,50,50)
        --
			physics.addBody(playerSpellCardObjects[1], "static",{friction=0.0, bounce=0.0, radius=w/2})
        --
            
            playerSpellCardObjects[1].gravityScale = 0
			playerSpellCardObjects[1].myName = "players spell card object"
		function playerSpellCardObjectMovement()
			if (i == nil) then i = 0 end
			i = i + 1
			playerSpellCardObjects[1].rotation = playerSpellCardObjects[1].rotation + 5
			playerSpellCardObjects[1].xScale = playerSpellCardObjects[1].xScale * 1.03
			playerSpellCardObjects[1].yScale = playerSpellCardObjects[1].yScale * 1.03
			if (i > 99) then
				for j = 1,#playerSpellCardObjects,1 do
					playerSpellCardObjects[j]:removeSelf()
				end
				playerSpellCardObjects = nil
				timer.cancel(playerSpellCard1Timer)
			end
			if (i > 99) then 
				i = 0
				player.spellCardInProgress = 0
			end
		end
		playerSpellCard1Timer = timer.performWithDelay(20, playerSpellCardObjectMovement, 100)
	else

	end




end
-------------------------------------------------------------------
spellcard_1 = function (a)
	-- create a cicle of danmaku
	-- move danmaku towawrds player
	a = createMakuInTable(50)
	circleMaku(100,a,w/2,h/4)
	for i = 1, #a, 1 do
		a[i].velocity = 0.5 --times game difficulty
		a[i]:setLinearVelocity(
			a[i].velocity*(player.x - a[i].x),
			a[i].velocity*(player.y - a[i].y)
		)
	end
end	
--[[ Still doesnt work going to do another one instead
function spellCard_2()
	steve = createMakuInTable(50)
	local counter = 0
	local prevpos = 0
		function spellCard_2Wave()
			counter = counter + 1
			local prevpos = prevpos + counter
			for i = prevpos, prevpos + counter, 1 do
				print("curerent loop:"..(i).." prevpos:"..prevpos.."counter is:"..counter)
				if i > #steve then
					timer.cancel(spellCard_2Timer)	
					return false
				end
				
				
				steve[i].x = w/2 + i*15 - 400
				steve[i].y = h/2
				steve[i].velocity = 1.1 --times game difficulty
				steve[i]:setLinearVelocity(
					steve[i].velocity*(player.x - steve[i].x),
					steve[i].velocity*(player.y - steve[i].y)
				)
			end
		end
	if counter > 10 then
		timer.cancel(spellCard_2Timer)
	end
	
	spellCard_2Timer = timer.performWithDelay( 20,spellCard_2Wave,#steve)
end
]]
spellCard_3 = function(a)
	a = createMakuInTable(100)
	i = 1
	function spellCard_3Wave()
		a[i].x = math.random(w)+w/100
		a[i].y = math.random((h/2))-h/50
		a[i].gravityScale = 1.5
		a[i]:setLinearVelocity(0,100*(i/25) + 100)
		on420BloomIt(a[i])
		i = i + 1
	end
	spellCard_3Timer = timer.performWithDelay( 50,spellCard_3Wave,#a)
	return a
end
-- collision
---------------------------------------------------------------------------------
function onGlobalCollision(event)
    print('reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee')
    
    if ( event.phase == "began" ) then
        print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )
 
    elseif ( event.phase == "ended" ) then
        print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
    end
    if(event.object1.myName == "players spell card object" and event.object2.myName == "enemy bullet") then
        print("removed")
        event.object2:removeSelf()
        event.object2 = nil    
    end
end
Runtime:addEventListener("collision",onGlobalCollision)
-------------------------------------------------------------------------------------
function on420BloomIt(object)
	object.fill.effect = "filter.bloom"
	object.fill.effect.levels.white = 0.8
	object.fill.effect.levels.black = 0.4
	object.fill.effect.levels.gamma = 1
	object.fill.effect.add.alpha = 0.8
	object.fill.effect.blur.horizontal.blurSize = 20
	object.fill.effect.blur.horizontal.sigma = 140
	object.fill.effect.blur.vertical.blurSize = 20
	object.fill.effect.blur.vertical.sigma = 240
end
------------------------------------------------------------------------------------
function onLocalCollision(self, event)
	
end
------------------------------------------------------------------------------------
--player movement
local function onKeyEvent( event )
	if (event.keyName == "left") then
		if (event.phase == "down") then
			playerNeedToMoveLeft = true
		else
			playerNeedToMoveLeft = false
		end
	end
	if (event.keyName == "right") then
		if (event.phase == "down") then
			playerNeedToMoveRight = true
		else
			playerNeedToMoveRight = false
		end
	end
	if (event.keyName == "up") then
		if (event.phase == "down") then
			playerNeedToMoveUp = true
		else
			playerNeedToMoveUp = false
		end
	end
	if (event.keyName == "down") then
		if (event.phase == "down") then
			playerNeedToMoveDown = true
		else
			playerNeedToMoveDown = false
		end
	end
	if (event.keyName == "leftShift") then
		if (event.phase == "down") then
			player.movementSpeedModifer = 0.5
		else
			player.movementSpeedModifer = 1
		end
	end
	if (event.keyName == "z") then
		if (event.phase == "down") then
			playerNeedtoShoot = true
		else
			playerNeedtoShoot = false
		end
	end
	if (event.keyName == "x") then
		if (event.phase == "down" and player.spellCardInProgress == 0) then
			playerSpellCard()
		end
	end
	if (event.keyName == "p") then
		if (event.phase == "down") then
			spellCard_3()
		end
	end	
    return false
end
---------------------------------------------------------------------------------
function playerShoot()
	if playerBullets == nil then playerBullets = {}	end
	function playerFire()
		playerBullets[#playerBullets] = display.newImageRect('danmakublue.png',w/30,w/30)
		playerBullets[#playerBullets].myName = "players bullet"
		physics.addBody(playerBullets[#playerBullets],"kinematic",{friction=0.0, bounce=0.0, density=0.0, radius=playerBullets[#playerBullets].contentWidth/2.0})
		playerBullets[#playerBullets].x = player.x
		playerBullets[#playerBullets].y = player.y - player.contentHeight/2
		playerBullets[#playerBullets]:setLinearVelocity(0,-50)
		removeSelfOnDelay(playerBullets[#playerBullets])
	end
	playerShootTimer = timer.performWithDelay( 0,playerFire,1)
end
 -----------------------------------------------------------------------------
-- movement of player
function gameLoopPlayerActions()
	if (playerNeedToMoveLeft == true and player.x > w/50) then
		player.x = player.x - player.movementSpeed * player.movementSpeedModifer
	end
	if (playerNeedToMoveRight == true and player.x < 49 * w/50) then
		player.x = player.x + player.movementSpeed * player.movementSpeedModifer
	end
	if (playerNeedToMoveUp == true and player.y > h/50) then
		player.y = player.y - player.movementSpeed * player.movementSpeedModifer
	end
	if (playerNeedToMoveDown == true and player.y < 49 * h/50) then
		player.y = player.y + player.movementSpeed * player.movementSpeedModifer
	end
	if (playerNeedtoShoot == true) then
		playerShoot()
	end
end
---------------------------------------------------------------------------
-- object remover
function removeSelfOnDelay(object)
	timer.performWithDelay(20000,function() object:removeSelf() end)
end

Runtime:addEventListener("enterFrame",gameLoopPlayerActions)
Runtime:addEventListener( "key", onKeyEvent )
