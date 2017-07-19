h = display.contentHeight
w = display.contentWidth
local physics = require("physics")
physics.start()
display.setDefault("textureWrapY", "repeat")
local background = display.newRect(display.contentCenterX, display.contentCenterY, w, h)
background.fill = {type = "image", filename = "succ1.jpg" }
local function animateBackground()
    transition.to( background.fill, { time=5000, y=-1, delta=true, onComplete=animateBackground } )
end
animateBackground()
--require("txtChartReader")
require("gameCode")
