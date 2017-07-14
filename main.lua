h = display.contentHeight
w = display.contentWidth
local physics = require("physics")
physics.start()
player = display.newRect(w/2,h,w/50,h/10)
player:setFillColor(1,1,1)
player.movementSpeed = 10
player.movementSpeedModifer = 1
physics.addBody(player,"kinematic",{friction=0.0, bounce=0.0, density=0.0, radius=player.contentWidth/2.0})
playerHitBox = display.newImageRect('danmaku1.png',w/30,w/30)
playerHitBox:setFillColor(1,0.5,0.5)
--function to create amount of maku inside a table
--table to be used for hit detection and shiizz
-- a is amount b is table




createMakuInTable = function (a)
	b = {}
	for i=1,a,1 do
		b[i] = display.newImageRect('danmaku1.png',w/30,w/30)
		physics.addBody(b[i], "kinematic",{friction=0.0, bounce=0.0, density=0.0, radius=b[i].contentWidth/2.0})
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

function spellCard_1()
	-- create a cicle of danmaku
	-- move danmaku towawrds player
	nerd = createMakuInTable(50)
	circleMaku(100,nerd,w/2,h/4)
	for i = 1, #nerd, 1 do
		nerd[i].velocity = 0.5 --times game difficulty
		nerd[i]:setLinearVelocity(
			nerd[i].velocity*(player.x - nerd[i].x),
			nerd[i].velocity*(player.y - nerd[i].y)
		)
	end
end	
function spellCard_2()
	steve = createMakuInTable(50)
		function spellCard_2Wave()
			local counter
			
			if (counter == #steve) then
				timer.cancel(spellCard_2Timer)
			end
			
			steve[i].velocity = 0.7 --times game difficulty
			steve[i]:setLinearVelocity(
				steve[i].velocity*(player.x - steve[i].x),
				steve[i].velocity*(player.y - steve[i].y)
			)
			
		counter = counter + 1
		end
	
	spellCard_2Timer = timer.performWithDelay( 20,spellCard_2Wave,-1)

end
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
	if (event.keyName == "p") then
			spellCard_2()
	end	

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end
 -----------------------------------------------------------------------------
-- movement of player
function gameLoopPlayerMovement()
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
	
end
-- Add the key event listener

Runtime:addEventListener("enterFrame",gameLoopPlayerMovement)
Runtime:addEventListener( "key", onKeyEvent )
