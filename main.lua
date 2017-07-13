h = display.contentHeight
w = display.contentWidth

player = display.newRect(w/2,h,w/50,h/10)
player:setFillColor(1,1,1)
--function to create amount of maku inside a table
--table to be used for hit detection and shiizz
-- a is amount b is table


createMakuInTable = function (a)
	b = {}
	for i=1,a,1 do
		b[i] = display.newImageRect('danmaku1.png',w/30,w/30)
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
	end
	return b
end

--This function creates an incresing value for animating
--the danmaku, uses a timer needs something better

--[[
function movelmao(event)
	local params = event.source.params
	circleMaku(params.i,nerd,w/2,h/2)
	params.i = params.i + 3
	print(nerd[1].y)
	if nerd[1].y > h/2 + h/100 then
		timer.cancel(event.source)
	end
end
tm = timer.performWithDelay( 20, movelmao, -1)
tm.params = { i = 1}
]]


--This function creates falling danmaku, attracted to player.
findAngleBetweenObjects = function(a,b)
	delta_x = a.x - b.x
	delta_y = b.x - a.x
	local radians = math.atan2(delta_y, delta_x)
	--returning degrees
	return radians*(180/math.pi)
end
--point and move all danmaku towards player
function spellCard_1()
	-- create a cicle of danmaku
	-- move danmaku towawrds player
	nerd = createMakuInTable(50)
	circleMaku(250,nerd,w/2,h/2)
	for i = 1, #nerd, 1 do
		nerd[i].rotation = findAngleBetweenObjects(nerd[i],player)
	end
	sleep(0.5)
	for i = 1, #nerd, 1 do
		nerd[i].dx = math.cos(nerd[i].rotation)
		nerd[i].dy = math.sin(nerd[i].rotation)
	end
end


local clock = os.clock
function sleep(n)  -- seconds
	local t0 = clock()
	while clock() - t0 <= n do end
end