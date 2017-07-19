local composer = require( "composer" )
h = display.contentHeight
w = display.contentWidth
-- Code to initialize your app
main_background = display.newImageRect( "images/mainmenubg.png", w, h )
main_background.x = w/2
main_background.y = h/2
main_background:toBack()
-- Assumes that "scene1.lua" exists and is configured as a Composer scene
settings_fadeIn = {
    effect = "slideUp",
    time = 200
}
composer.gotoScene( "mainmenu", settings_fadeIn )