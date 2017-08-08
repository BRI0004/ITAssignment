h = 768
w = 1024  
player = love.graphics.newImage('succ.jpg')
--[[
player.movementSpeed = 10
player.movementSpeedModifer = 1
player.powerlevel = 1
player.selectedSpellCard = 1
player.spellCardInProgress = 0
player.myName = "player object"
]]
playerHitBox = love.graphics.newImage('succ.jpg')
--[[
function object:Draw()
  if self.image then
    love.graphics.draw(
      self.image, self.body:getX(), self.body:getY(), self.body:getAngle(),
      1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2
    )
  else
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  end
end
player:Draw()

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





playerSpellCardObjectsPlayerX = 0
playerSpellCardObjectsPlayerY = 0
function playerSpellCard()
	playerSpellCardObjectsPlayerX = player.x
	playerSpellCardObjectsPlayerY = player.y
	if (player.selectedSpellCard == 1) then
		player.spellCardInProgress = 1
		if playerSpellCardObjects == nil then
			playerSpellCardObjects = {}
		end
			-- player spell card 1, rotating boxes that remove any danmaku
			playerSpellCardObjects[1] = display.newRect(player.x, player.y,50,50)
        --
			physics.addBody(playerSpellCardObjects[1], "dynamic",{friction=0.0, bounce=0.0, radius=w/2})
        --
		
playerSpellCardObjects[1].preCollision = onLocalPreCollision
playerSpellCardObjects[1]:addEventListener( "preCollision" )
		

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
					playerSpellCardObjects[j]=nil
				end
				playerSpellCardObjects = nil
				timer.cancel(playerSpellCard1Timer)
			end
			if (i > 99) then 
				i = 0
				player.spellCardInProgress = 0
			end
		end
		playerSpellCard1Timer = timer.performWithDelay(10, playerSpellCardObjectMovement, 200)
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
function spellCard_3(a)
	a = createMakuInTable(100)
	local i = 1
	math.randomseed(12312)
	function spellCard_3Wave()
		a[i].x = math.random(w)+w/100
		a[i].y = math.random((h/2))-h/50
		a[i].gravityScale = 1.5
		a[i]:setLinearVelocity(0,100*(i/25) + 100)
		i = i + 1
	end
	if i >= 99 then
		timer.cancel(spellCard_3Timer)
	end
	spellCard_3Timer = timer.performWithDelay( 50,spellCard_3Wave,#a)
	return a
end
-- collision
---------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Local preCollision handling
function onLocalPreCollision( self, event )
    print( event.target )       --the first object in the collision
    print( event.other )         --the second object in the collision
    print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    print( event.otherElement )  --the element (number) of the second object which was hit in the collision
	if (event.target.myName == "players spell card object" and event.other.myName == "enemy bullet") then
		physics.removeBody(event.other)
		display.remove(event.other)
		event.other.x = 99999999
	end
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
			spellCard_3(maesm)
		end
	end	
    return false
end
--------------------------------------------------------------------------------
function getDistance(objA, objB)
    -- Get the length for each of the components x and y
    local xDist = objB.x - objA.x
    local yDist = objB.y - objA.y

    return math.sqrt( (xDist ^ 2) + (yDist ^ 2) ) 
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
		playerBullets[#playerBullets]:setLinearVelocity(0,-800)
		removeSelfOnDelay(playerBullets[#playerBullets])
	end
	playerShootTimer = timer.performWithDelay( 20,playerFire,1)
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
    playerHitBox.x,playerHitBox.y = player.x,player.y
	if playerSpellCardObjects ~= nil then
		playerSpellCardObjects[1].x,playerSpellCardObjects[1].y = playerSpellCardObjectsPlayerX,playerSpellCardObjectsPlayerY
	end
end
---------------------------------------------------------------------------
-- object remover
function removeSelfOnDelay(object)
	timer.performWithDelay(20000,function() object:removeSelf() end)
end