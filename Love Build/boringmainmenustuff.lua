love.mousepressed = function(x, y, button)
	if menu_dialog then
		state.mainmenu.gui:mousepress(x, y, button) -- pretty sure you want to register mouse events
	elseif freemode_menu then
		state.freemode_menu.gui:mousepress(x, y, button) -- pretty sure you want to register mouse events
	end
end
ffont = "assets/AlteHaasGroteskRegular.ttf"
--functions for main menu_dialog
--9:55 thursday the 8th.... i dont understand how classes work propery, hope this works
--10 pm didnt work
--10:06pm fixed it wew
--10:09 pm all work as it did earlier
gui = require("Gspot")
function loadthestuff()
	state = {
		common = {gui = gui()},
		mainmenu = {
			gui = gui(),
			update = function(dt)
				state.common.gui:update(dt)
				state.mainmenu.gui:update(dt)
			end,
			draw = function()
				state.mainmenu.gui:draw()
				love.graphics.setNewFont(ffont,80)
				love.graphics.setColor(255,255,255,255)
				love.graphics.printf("Bullet Heaven", 95, 100,500)
				love.graphics.setNewFont(ffont,24)
				love.graphics.printf("A game by Liam Bridge and Matthew Low", 100, 200,800)
			end,
			load = function()
				local storyModeButton = state.mainmenu.gui:button('Story Mode', {x = 100, y = 250, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				storyModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Story Mode Selected")
				end
				local freeModeButton = state.mainmenu.gui:button('Free Mode', {x = 100, y = 350, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				freeModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Free Mode Selected")
					menu_dialog = false
					freemode_menu = true
					print(freemode_menu)
				end
				local marathonModeButton = state.mainmenu.gui:button('Marathon Mode', {x = 100, y = 450, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				marathonModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Marathon Mode Selected")
				end
				print("loaded main menu")
			end
		},
		----------------------------------------------------------------------------------------------------------------
		freemode_menu={
			gui = gui(),
			update = function(dt)
				state.common.gui:update(dt)
				state.freemode_menu.gui:update(dt)
				list:update(dt)
				if list:isdoublec() then
		            mselected=list:getselected()
		            source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		            love.audio.stop()
		            source:play()
		            mduration=source:getDuration(unit)
		            mpos=source:tell(unit)
		        end
				if source and source:isPlaying() then
		            mpos=source:tell(unit)
		        elseif source and not source:isPlaying() then
		            local count = list:getcount()
		            if random then
		                mselected=(math.random(count))
		                list:setselected(mselected)
		                source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		                source:play()
		            else
		                if mselected+1<=count then
		                    mselected=mselected+1
		                    list:setselected(mselected)
		                    source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		                    source:play()
		                else
		                    mselected=1
		                    list:setselected(mselected)
		                    source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		                    source:play()
		                end
		            end
		            mduration=source:getDuration(unit)
		        end

		        list:update(dt)
				print(source:isPlaying())
			end,
			draw = function()
				-- ui elements
				state.freemode_menu.gui:draw()
				love.graphics.setColor(255,255,255,255)

				love.graphics.setNewFont(ffont,60)
				love.graphics.printf("Song Select", 95, 250,500)
				love.graphics.rectangle("line", 95, 50, 450, 200)
				love.graphics.setNewFont(ffont,25)
				love.graphics.printf("If you can see this something has gone wrong; art placeholder", 105, 60 ,400)

				-- list of songs
				list:draw()

		        if source and source:isPlaying() then
		            love.graphics.setColor(list.fcolor)
		            nowp("Now Playing "..list:concat(mselected))
		        end
		        love.graphics.setColor(list.fcolor)

		        list:draw()

			end,
			load = function()
				print("desued")
				local tlist={
					x=550, y=50,
					font=love.graphics.setNewFont(ffont, 30),ismouse=true,
					rounded=true,bordercolor={0,0,255}, -- border color RGB (table)
					selectedcolor={50,50,50}, -- selected color RGB (table)
					fselectedcolor={255,0,0}, -- font selected color RGB (table)
					bgcolor={20,20,20},
					w=400,h=700,showindex=true,
					fcolor = {255,255,255},
					showindex = false,
					ismouse = true,
					istouch = false,
					selected = 1,

				}
				list:newprop(tlist)
				dir="songs/audio"
		        img="songs/img"
		        files = list:enudir(dir,".mp3 .wav .ogg .wma")
				if files then
		            for i, mus in ipairs(files) do
		                mus=dir.."/"..mus
		                list:additem(list:getfilename(mus),list:getfileext(mus))
		            end
		        end
				function love.keypressed(key)
			        local selected = list:getselected()
					if key == "escape" then
						freemode_menu = false
						menu_dialog = true
					end
			        if key == "return" or key == "kpenter" then
						--[[
			            source = love.audio.newSource(dir.."/"..list:getfusion(selected))
			            love.audio.stop()
			            source:play()
			            mduration=source:getDuration(unit)
			            mselected=selected
						love.audio.play(source)
						freemode_menu = false
						game_dialog = true
						]]
						love.audio.stop()
						mselected=selected
						print(selected, mselected)
						print("logging")
						print(list:getfusion(selected))
						source = love.audio.newSource(dir.."/"..list:getfusion(selected),"stream")
						mduration = source:getDuration(unit)
						love.audio.play(source)
			        end
			        list:key(key)
			    end
				if list:maxn() and list:maxn()>=4 then
		            list:autosize(true)
		        end

		        if list:maxn() then
		            mselected=1
		            source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		            source:play()
		            mduration=source:getDuration(unit)
		        end
				function nowp(str)
				    local width = font:getWidth(str)*4
				    local height = font:getHeight(str)*4
				    if (play_x+width)>20 then
				        play_x=play_x-3
				    else
				        play_x=list.gw-20
				    end
				    love.graphics.print(str, play_x, 20,0,4,4)
				end
			end,
		},
		example={
			gui = gui(),
			update = function(dt)

			end,
			draw = function()

			end,
			load = function()

			end,
		},
		game_play = {
			gui = gui(),
			update = function(dt)

				if source and source:isPlaying() then
					mpos=source:tell(unit)
				end
				print(source, 'is sause')
				print(source:isPlaying())
				if list:isdoublec() then
		            mselected=list:getselected()
		            source = love.audio.newSource(dir.."/"..list:getfusion(mselected))
		            love.audio.stop()
		            source:play()
		            mduration=source:getDuration(unit)
		            mpos=source:tell(unit)
		        end
			end,
			draw = function()

			end,
			load = function()
			end,
		}
	}

end

-- functoins for free mode
