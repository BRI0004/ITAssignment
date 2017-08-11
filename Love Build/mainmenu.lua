mpos,mduration = 0,0
currentSongBPM = 0
love.mousepressed = function(x, y, button)
	if menu_dialog then
		state.mainmenu.gui:mousepress(x, y, button) -- pretty sure you want to register mouse events
	end
	if story_mode_select_menu then
		state.story_mode_select.gui:mousepress(x, y, button) -- pretty sure you want to register mouse events
	end
end
ffont = "assets/AlteHaasGroteskRegular.ttf"
ffontbold = "assets/AlteHaasGroteskBold.ttf"
--functions for main menu_dialog
--9:55 thursday the 8th.... i dont understand how classes work propery, hope this works
--10 pm didnt work
--10:06pm fixed it wew
--10:09 pm all work as it did earlier
gui = require("libraries/Gspot")
wave = require("libraries/wave")
displayTitleText = 'Alien'
displaySubtitleText = 'Maximum The Hormone'
displayBPMText = '276'
math.randomseed(os.time())
randomNumber = math.random(1, 5)
function loadBGOverlay()
	if images["overlay"][currentFileNameWoExt] == nil then
		if love.filesystem.exists("songs/img/"..currentFileNameWoExt.."/overlay.png") then
			images["overlay"][currentFileNameWoExt] = love.graphics.newImage("songs/img/"..currentFileNameWoExt.."/overlay.png")
		else
			print("file " .."songs/img/"..currentFileNameWoExt.."/overlay.png".." expected")
		end
	end
	if images["bg"][currentFileNameWoExt] == nil then
		if love.filesystem.exists("songs/img/"..currentFileNameWoExt.."/bg.png") then
			images["bg"][currentFileNameWoExt] = love.graphics.newImage("songs/img/"..currentFileNameWoExt.."/bg.png")
		else
			print("file " .."songs/img/"..currentFileNameWoExt.."/bg.png".." expected")
		end
	end
end
function previewAndSelect()
	currentFileNameWoExt = string.sub(list:getfusion(listselected),1,string.len(list:getfusion(listselected))-4)
	if love.filesystem.exists("songs/maps/"..currentFileNameWoExt..".txt") then
		chunk = love.filesystem.load("songs/maps/"..currentFileNameWoExt..".txt" ) -- load the chunk
		result = chunk() -- execute the chunk
	end
	if previewSource ~= nil then
		love.audio.stop()
	end
	loadBGOverlay()
	previewSource = love.audio.newSource("songs/audio/"..list:getfusion(listselected), "stream")
	love.audio.play(previewSource)
	previewSource:seek(maps[currentFileNameWoExt].metadata.previewTime,"seconds")
	love.audio.setVolume(0.2)
	displayTitleText = currentFileNameWoExt
	displaySubtitleText = "Artist: ".. maps[currentFileNameWoExt].metadata.artist
	displayBPMText = "BPM: ".. maps[currentFileNameWoExt].metadata.BPM
end
function loadthestuff()
	state = {
		common = {gui = gui()},
		mainmenu = {
			gui = gui(),
			update = function(dt)
				state.common.gui:update(dt)
				state.mainmenu.gui:update(dt)
			end,
			load = function()
				backgroundImage = love.graphics.newImage("assets/img/"..randomNumber.. ".png")
				local storyModeButton = state.mainmenu.gui:button('Story Mode', {x = 100, y = 250, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				storyModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Story Mode Selected")
					menu_dialog = false
					story_mode_select_menu = true
				end
				local freeModeButton = state.mainmenu.gui:button('Free Mode', {x = 100, y = 330, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				freeModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Free Mode Selected")
					menu_dialog = false
					freemode_menu = true
					listselected = 1
					previewAndSelect()
				end
				local marathonModeButton = state.mainmenu.gui:button('Marathon Mode', {x = 100, y = 410, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				marathonModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Marathon Mode Selected")
				end
				print("loaded main menu")
			end,
			draw = function()
				love.graphics.draw(backgroundImage, 0, 0, r, 1, 1, ox, oy, kx, ky)
				state.mainmenu.gui:draw()
				love.graphics.setNewFont(ffontbold,120)
				love.graphics.setColor(255,255,255,255)
				love.graphics.printf("Bullet Heaven", 95, 70 ,1000)
				love.graphics.setNewFont(ffont,24)
				love.graphics.printf("A game by Liam Bridge and Matthew Low", 100, 200,800)
			end,
		},
		----------------------------------------------------------------------------------------------------------------
		freemode_menu={
			update = function(dt)
				list:update(dt)
				listselected = list:getselected()

			end,
			draw = function()
				-- ui elements
				--draw bg at the back
				if images["bg"][currentFileNameWoExt] ~= nil then
					if love.filesystem.exists("songs/img/"..currentFileNameWoExt.."/bg.png") then
						love.graphics.draw(images["bg"][currentFileNameWoExt], 0, 0, 0,(1280/images["bg"][currentFileNameWoExt]:getWidth()),720/(images["bg"][currentFileNameWoExt]:getHeight()))
					end
				end
				love.graphics.setColor(255,255,255,255)
				love.graphics.setNewFont(ffontbold,24)
				love.graphics.printf("Song Select", 95, 15,500)
				love.graphics.setNewFont(ffontbold,48)
				displayTitle = love.graphics.printf(displayTitleText, 95, 270,750)
				love.graphics.setNewFont(ffont,30)
				displaySubtitle = love.graphics.printf(displaySubtitleText, 95, 325,500)
				displayBPM = love.graphics.printf(displayBPMText, 95, 360,500)
				love.graphics.rectangle("line", 95, 50, 450, 200)
				love.graphics.setNewFont(ffont,25)
				love.graphics.printf("overlay.png missing", 105, 60 ,400)
				if images["overlay"][currentFileNameWoExt] ~= nil then
					if love.filesystem.exists("songs/img/"..currentFileNameWoExt.."/overlay.png") then
						love.graphics.draw(images["overlay"][currentFileNameWoExt], 95, 50, 0,(450/images["overlay"][currentFileNameWoExt]:getWidth()),(200/images["overlay"][currentFileNameWoExt]:getHeight()))
					end
				end
				list:draw()
			end,
			load = function()

				images = {
					bg = {},
					overlay = {}
				}
				maps = {}
				local tlist={
					x=785, y=50,
					font=love.graphics.setNewFont(ffont, 24),
					rounded=false,
					bordercolor={60,60,60}, -- border color RGB (table)
					selectedcolor={255,255,255}, -- selected color RGB (table)
					fselectedcolor={0,0,0}, -- font selected color RGB (table)
					bgcolor={60,60,60},
					w=400,h=620,showindex=true,
					fcolor = {255,255,255},
					showindex = false,
					ismouse = false,
					istouch = false,
					selected = 1,
					radius=0,

				}
				list:newprop(tlist)
				dir="songs/audio"
				img="songs/img"
				files = list:enudir(dir,".mp3 .wav .ogg")
				if files then
					for i, mus in ipairs(files) do
						mus=dir.."/"..mus
						list:additem(list:getfilename(mus),list:getfileext(mus))
					end
				end
				function love.keypressed(key)
					if freemode_menu then
						if key == "down" then
							if list:getselected() ~= list:getcount() then
								listselected = list:getselected() + 1
								previewAndSelect()
							end
						elseif key == "up" then
							if list:getselected() ~= 1 then
								listselected = list:getselected() - 1
								previewAndSelect()
							end
						end



						if key == "return" or key == "kpenter" then
							love.audio.stop(previewSource)

							if love.filesystem.exists("songs/maps/"..currentFileNameWoExt..".txt") then
								chunk = love.filesystem.load("songs/maps/"..currentFileNameWoExt..".txt" ) -- load the chunk
								result = chunk() -- execute the chunk
								currentSongBPM = maps[currentFileNameWoExt].metadata.BPM
							else
								love.window.showMessageBox("Error", "No Data Found")
							end
							love.audio.stop()
							source = love.audio.newSource("songs/audio/"..list:getfusion(listselected), "stream")
							love.audio.play(source)
							source:play()
							mduration=source:getDuration(unit)
							mlistselected = listselected
							freemode_menu = false
							game_dialog = true
						end
						if key == "escape" then
							freemode_menu = false
							menu_dialog = true
							love.audio.stop()
						end
						list:key(key)
					end
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
		story_mode_select = {
			gui = gui(),
			update = function(dt)
				state.common.gui:update(dt)
				state.story_mode_select.gui:update(dt)
			end,
			draw = function()
				love.graphics.draw(backgroundImage, 0, 0, r, 1, 1, ox, oy, kx, ky)
				state.story_mode_select.gui:draw()
				love.graphics.draw(blacksquare, 116, 76, 0, 4, 1.5)
			end,
			load = function()
				local group1Button = state.story_mode_select.gui:button('', {x = 100, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group1Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Story Mode Selected")
					print("dezu")
				end
				local group2Button = state.story_mode_select.gui:button('Group 2', {x = 456, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group2Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Free Mode Selected")
				end
				local group3Button = state.story_mode_select.gui:button('Group 3', {x = 812, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group3Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Marathon Mode Selected")
				end
				local group4Button = state.story_mode_select.gui:button('Group 4', {x = 100, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group4Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Story Mode Selected")
					print("dezu")
				end
				local group5Button = state.story_mode_select.gui:button('Group 5', {x = 456, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group5Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Free Mode Selected")
				end
				local group6Button = state.story_mode_select.gui:button('Group 6', {x = 812, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				group6Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.story_mode_select.gui:feedback("Marathon Mode Selected")
				end
				blacksquare = love.graphics.newImage("assets/player.png")
			end,
		},
		game_play = {
			gui = gui(),
			update = function(dt)
				BPMtoDTCount = BPMtoDTCount + dt
				if source and source:isPlaying() then
					mpos=source:tell(unit)
				end
				if mpos + 1 > mduration then
					love.audio.stop()
				end
				if BPMtoDTCount > 60/currentSongBPM then
					BPMtoDTCount = 0
					--if ChartLocation % 2 == 0 then print(#enemies) addEnemy(400,1,10,2) end
					if maps[currentFileNameWoExt].chart[ChartLocation] ~= nil then
						maps[currentFileNameWoExt].chart[ChartLocation]()
					else
						print("no chart for this Beat")
					end

					print("Beat",ChartLocation)
					ChartLocation = ChartLocation + 1
				end--
			end,
			draw = function()

			end,
			load = function()
				BPMtoDTCount = 0
				ChartLocation = 0
			end,
		}
	}

end

-- functoins for free mode
