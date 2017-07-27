local composer = require( "composer" )
local widget = require( "widget" )

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
    freemode_titleText = display.newText( "Free Mode: Song Select", 100,100, "ahgb.ttf", 96 )
    freemode_titleText.anchorX = 0
    freemode_titleText.align = "left"
    freemode_subtitleText = display.newText( "Select your song level.", 100,175, "ahgr.ttf", 24 )
    freemode_subtitleText.anchorX = 0
    freemode_subtitleText.align = "left"
    sceneGroup:insert(freemode_titleText)
    sceneGroup:insert(freemode_subtitleText)
    -- Create the widget
    local scrollView = widget.newScrollView(
        {
            width = 606,
            height = 520,
            top = 200,
            left = 100,
            scrollWidth = 600,
            hideBackground = true,
            horizontalScrollDisabled = true
        }
    )
    sceneGroup:insert(scrollView)
    freemode_songRectList = {}
    freemode_songRectTextList = {}
    for i=1,10 do
        freemode_songRect = display.newRect( 303 ,(50*i), 594, 50 )
        freemode_songRect.strokeWidth = 3
        freemode_songRect:setFillColor( 1,1,1,0 )
        freemode_songRect:setStrokeColor( 1,1,1 )
        scrollView:insert(freemode_songRect)
        local path = i
        local file, errorString = io.open( "songs/" ..  i .. ".txt", "r" )
         
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- Read data from file
            local contents = file:read( "*a" )
            -- Output the file contents
            freemode_songRectText = display.newText( contents, 30,(50*i), "ahgr.ttf", 20 )
            freemode_songRectText.anchorX = 0
            freemode_songRectText.align = "left"
            scrollView:insert(freemode_songRectText)
            -- Close the file handle
            io.close( file )
        end
        file = nil
        table.insert(freemode_songRectList, i)
        table.insert(freemode_songRectTextList, i)
    end
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        local function onMouseEvent( event )
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