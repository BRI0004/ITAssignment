local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    h = display.contentHeight
    w = display.contentWidth
    local sceneGroup = self.view
    background = display.newImageRect( "images/mainmenubg.png", w, h )
    background.x = w/2
    background.y = h/2
    titleText = display.newText( "Bullet Heaven", w/2, h/4, "fmm.ttf", 48 )
    subtitleText = display.newText( "A game created by Liam Bridge and Matthew Low", w/2, 3*h/8, "fmr.ttf", 24 )
    startButton = display.newRoundedRect( w/2, 5*h/8, w/4, h/8, 24 )
    startButton.strokeWidth = 3
    startButton:setFillColor( 1,1,1,0 )
    startButton:setStrokeColor( 1,1,1 )
    startButtonText = display.newText( "START", w/2, 5*h/8, "fmr.ttf", 36 )
    langButton = display.newRoundedRect( w/2, 7*h/8, w/8, h/16, 12 )
    langButton.strokeWidth = 3
    langButton:setFillColor( 1,1,1,0 )
    langButton:setStrokeColor( 1,1,1 )
    langButtonText = display.newText( "English", w/2, 7*h/8, "fmr.ttf", 16 )
    sceneGroup:insert(background)
    sceneGroup:insert(titleText)
    sceneGroup:insert(subtitleText)
    sceneGroup:insert(startButton)
    sceneGroup:insert(startButtonText)
    sceneGroup:insert(langButton)
    sceneGroup:insert(langButtonText)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        local function onMouseEvent( event )
            local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
            print( message )
            if event.x >= 3*w/8 and event.x <= 5*w/8 and event.y >= 9*h/16 and event.y <= 11*h/16 then
                startButton:setFillColor(1,1,1,1)
                startButtonText:setFillColor(0,0,0)
            else
                startButton:setFillColor(1,1,1,0)
                startButtonText:setFillColor(1,1,1)
            end
            if event.x >= 7*w/16 and event.x <= 9*w/16 and event.y >= 13*h/16 and event.y <= 15*h/16 then
                langButton:setFillColor(1,1,1,1)
                langButtonText:setFillColor(0,0,0)
            else
                langButton:setFillColor(1,1,1,0)
                langButtonText:setFillColor(1,1,1)
            end
        end
        Runtime:addEventListener( "mouse", onMouseEvent )
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene