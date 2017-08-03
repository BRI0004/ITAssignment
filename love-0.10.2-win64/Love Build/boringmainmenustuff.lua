function loadthestuff()
    local button = gui:button('A Button', {x = 128, y = gui.style.unit, w = 128, h = gui.style.unit}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
	button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
		gui:feedback('Clicky')
	end
end
function drawmainmenutext()
    ffont = "assets/AlteHaasGroteskRegular.ttf"
    love.graphics.setNewFont(ffont,80)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf("Bullet Heaven", 95, 100,500)
    love.graphics.setNewFont(ffont,24)
    love.graphics.printf("A game by Liam Bridge and Matthew Low", 100, 200,800)
    local x, y = love.mouse.getPosition()
    if x > 100 then
        print("4")
        if x < 300 then
            print("2")
            if y > 350 then
                print("1")
                if y < 250 then
                    print("asd")
                end
            end
        end
    else
        love.graphics.rectangle("line", 100, 250, 200, 100)
    end
end
