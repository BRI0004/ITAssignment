local composer = require( "composer" )
 
-- Code to initialize your app
 
-- Assumes that "scene1.lua" exists and is configured as a Composer scene
local fadeIn = {
    effect = "crossFade",
    time = 1000
}
composer.gotoScene( "mainmenu", fadeIn )