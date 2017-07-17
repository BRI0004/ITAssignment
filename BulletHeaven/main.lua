-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
native.setProperty( "mouseCursorVisible", false )

local w = display.contentWidth
local h = display.contentHeight
local image = display.newImageRect( "touhou.jpg", w, h )
image.x = w/2
image.y = h/2
local myRectangle = display.newRect( w/2, h/16, w, h/8 )
myRectangle:setFillColor( 0.1 )
local image = display.newImageRect( "hakase.png", 80, 80 )
local label1 = display.newText( "Song", w/32, h/32, "fmr.ttf", 16 )
local label2 = display.newText( "Diff", 4*w/16, h/32, "fmr.ttf", 16 )
local label3 = display.newText( "BPM", 6*w/16, h/32, "fmr.ttf", 16 )
local label4 = display.newText( "Length", 15*w/32, h/32, "fmr.ttf", 16 )
local label5 = display.newText( "Score", 9*w/16, h/32, "fmr.ttf", 16 )
local label6 = display.newText( "Status", 13*w/16, h/32, "fmr.ttf", 16 )

local title1a = display.newText( "Hold Your Colour", w/32, 2*h/32, "fmm.ttf", 16 )
local title1b = display.newText( "Pendulum", w/32, 3*h/32, "fmr.ttf", 16 )
local title2a = display.newText( "851", 4*w/16, 2*h/32, "fmm.ttf", 16 )
local title2b = display.newText( "Lunatic", 4*w/16, 3*h/32, "fmr.ttf", 16 )
local title3 = display.newText( "174", 6*w/16, 2*h/32, "fmm.ttf", 16 )
local title4a = display.newText( "3:11", 15*w/32, 2*h/32, "fmr.ttf", 16 )
local title4b = display.newText( "5:28", 15*w/32, 3*h/32, "fmr.ttf", 16 )
local title5a = display.newText( "128500600", 9*w/16, 5*h/64, "fmm.ttf", 40 )
local title5b = display.newText( "256000000", 10*w/16, 1*h/32, "fmm.ttf", 16 )
local title6a = display.newText( "Focus", 13*w/16, 2*h/32, "fmr.ttf", 16 )
local title6b = display.newText( "Spell Card", 13*w/16, 3*h/32, "fmr.ttf", 16 )

label1.anchorX = 0
label1.align = "left"
label2.anchorX = 0
label2.align = "left"
label3.anchorX = 0
label3.align = "left"
label4.anchorX = 0
label4.align = "left"
label5.anchorX = 0
label5.align = "left"
label6.anchorX = 0
label6.align = "left"
title1a.anchorX = 0
title1a.align = "left"
title1b.anchorX = 0
title1b.align = "left"
title2a.anchorX = 0
title2a.align = "left"
title2a:setFillColor (1,0.1,0.1)
title2b.anchorX = 0
title2b.align = "left"
title3.anchorX = 0
title3.align = "left"
title4a.anchorX = 0
title4a.align = "left"
title4b.anchorX = 0
title4b.align = "left"
title4b:setFillColor(0.5,0.5,0.5)
title5a.anchorX = 0
title5a.align = "left"
title5b.anchorX = 0
title5b.align = "left"
title6a.anchorX = 0
title6a.align = "left"
title6a:setFillColor(0.5,0.5,0.5)
title6b.anchorX = 0
title6b.align = "left"
title6b:setFillColor(0.5,0.5,0.5)


local fpsDisplay = display.newText ( "", 31*w/32, 31*h/32, "fmr.ttf", 16)
fpsDisplay.width = w/8
fpsDisplay.align = "right"

local function onMouseEvent( event )
    -- Print the mouse cursor's current position to the log.
    local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
    print( message )
    image.x = event.x
    image.y = event.y
end
                  
local function updateFPS (event)
	fpsDisplay.text = display.fps .. " FPS"
end            

-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )
Runtime:addEventListener( "enterFrame", updateFPS)