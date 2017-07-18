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
    local sceneGroup = self.view
    mainmenu_titleText = display.newText( "Bullet Heaven", 100, 100, "ahgb.ttf", 96 )
    mainmenu_titleText.anchorX = 0
    mainmenu_titleText.align = "left"
    mainmenu_subtitleText = display.newText( "A game created by Liam Bridge and Matthew Low", 100, 175, "ahgr.ttf", 24 )
    mainmenu_subtitleText.anchorX = 0
    mainmenu_subtitleText.align = "left"
    mainmenu_startButton = display.newRect( 300, 300, 400, 100 )
    mainmenu_startButton.strokeWidth = 3
    mainmenu_startButton:setFillColor( 1,1,1,0 )
    mainmenu_startButton:setStrokeColor( 1,1,1 )
    mainmenu_startButtonText = display.newText( "Free Mode", 125, 300, "ahgr.ttf", 36 )
    mainmenu_startButtonText.anchorX = 0
    mainmenu_startButtonText.align = "left"
    mainmenu_storyButton = display.newRect( 300, 400, 400, 100 )
    mainmenu_storyButton.strokeWidth = 3
    mainmenu_storyButton:setFillColor( 1,1,1,0 )
    mainmenu_storyButton:setStrokeColor( 1,1,1 )
    mainmenu_storyButtonText = display.newText( "Story Mode", 125, 400, "ahgr.ttf", 36 )
    mainmenu_storyButtonText.anchorX = 0
    mainmenu_storyButtonText.align = "left"
    mainmenu_unlocksButton = display.newRect( 300, 500, 400, 100 )
    mainmenu_unlocksButton.strokeWidth = 3
    mainmenu_unlocksButton:setFillColor( 1,1,1,0 )
    mainmenu_unlocksButton:setStrokeColor( 1,1,1 )
    mainmenu_unlocksButtonText = display.newText( "Unlocks", 125, 500, "ahgr.ttf", 36 )
    mainmenu_unlocksButtonText.anchorX = 0
    mainmenu_unlocksButtonText.align = "left"
    mainmenu_langButton = display.newRect( 200, 600, 200, 50 )
    mainmenu_langButton.strokeWidth = 3
    mainmenu_langButton:setFillColor( 1,1,1,0 )
    mainmenu_langButton:setStrokeColor( 1,1,1 )
    mainmenu_langButtonText = display.newText( "English", 112.5, 600, "ahgr.ttf", 16 )
    mainmenu_langButtonText.anchorX = 0
    mainmenu_langButtonText.align = "left"
    sceneGroup:insert(mainmenu_titleText)
    sceneGroup:insert(mainmenu_subtitleText)
    sceneGroup:insert(mainmenu_startButton)
    sceneGroup:insert(mainmenu_startButtonText)
    sceneGroup:insert(mainmenu_langButton)
    sceneGroup:insert(mainmenu_langButtonText)
    sceneGroup:insert(mainmenu_storyButton)
    sceneGroup:insert(mainmenu_storyButtonText)
    sceneGroup:insert(mainmenu_unlocksButton)
    sceneGroup:insert(mainmenu_unlocksButtonText)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        local function onMouseEvent( event )	
            if event.x >= 100 and event.x <= 500 and event.y >= 250 and event.y <= 350 then
                mainmenu_startButton:setFillColor(1,1,1,1)
                mainmenu_startButtonText:setFillColor(0,0,0)
                if event.isPrimaryButtonDown then
                    composer.gotoScene( "freemode", settings_fadeIn )
                end
            else
                mainmenu_startButton:setFillColor(1,1,1,0)
                mainmenu_startButtonText:setFillColor(1,1,1)
            end
            if event.x >= 100 and event.x <= 500 and event.y >= 350 and event.y <= 450 then
                mainmenu_storyButton:setFillColor(1,1,1,1)
                mainmenu_storyButtonText:setFillColor(0,0,0)
            else
                mainmenu_storyButton:setFillColor(1,1,1,0)
                mainmenu_storyButtonText:setFillColor(1,1,1)
            end
            if event.x >= 100 and event.x <= 500 and event.y >= 450 and event.y <= 550 then
                mainmenu_unlocksButton:setFillColor(1,1,1,1)
                mainmenu_unlocksButtonText:setFillColor(0,0,0)
            else
                mainmenu_unlocksButton:setFillColor(1,1,1,0)
                mainmenu_unlocksButtonText:setFillColor(1,1,1)
            end
            if event.x >= 100 and event.x <= 300 and event.y >= 575 and event.y <= 625 then
                mainmenu_langButton:setFillColor(1,1,1,1)
                mainmenu_langButtonText:setFillColor(0,0,0)
            else
                mainmenu_langButton:setFillColor(1,1,1,0)
                mainmenu_langButtonText:setFillColor(1,1,1)
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