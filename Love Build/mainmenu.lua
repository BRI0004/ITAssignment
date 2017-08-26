mpos,mduration = 0,0
currentSongBPM = 0
desu = {1,2,3,4,5,6,7,8}
binser.writeFile("profile.txt",desu)
desu = binser.writeFile("profile.txt")

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
gui = require("libraries/Gspot")
wave = require("libraries/wave") -- requite some locacl libraries
displayTitleText = 'Alien'
displaySubtitleText = 'Maximum The Hormone'
displayBPMText = '276' -- sets default text
math.randomseed(os.time())
randomNumber = math.random(1, 5)
function loadBGOverlay() -- function to load the images of the background and title of song
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
function multiplayerServerIP()  -- not implemented
	local input = gui:input('Chat', {64, love.graphics.getHeight() - 32, 256, gui.style.unit})
	input.keyrepeat = true -- this is the default anyway
	input.done = function(this) -- Gspot calls element:done() when you hit enter while element has focus. override this behaviour with element.done = false
		gui:feedback('I say '..this.value)
		this.value = ''
		this.Gspot:unfocus()
	end
	local button = gui:button('Speak', {input.pos.w + gui.style.unit, 0, 200, gui.style.unit}, input) -- attach a button
	button.click = function(this)
		this.parent:done()
	end

end
function previewAndSelect() -- plays preview of sonog and loads bg and stuff
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
function loadthestuff() -- main function with all stuff in it
	state = {
		common = {gui = gui()},
		mainmenu = {
			gui = gui(),
			update = function(dt)
				state.common.gui:update(dt)
				state.mainmenu.gui:update(dt)
			end,
			load = function() -- loads main menu and stuff
				backgroundImage = love.graphics.newImage("assets/img/"..randomNumber.. ".png")
				local storyModeButton = state.mainmenu.gui:button('Story Mode', {x = 100, y = 250, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				storyModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Story Mode Selected")
					menu_dialog = false
					story_mode_select_menu = true
					freemode_menu = false
					story_mode = true
				end
				local freeModeButton = state.mainmenu.gui:button('Free Mode', {x = 100, y = 330, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				freeModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Free Mode Selected")
					menu_dialog = false
					freemode_menu = true
					story_mode_select_menu = false
					listselected = 1
					previewAndSelect()
				end
				-- doesnt work bye
				--[[
				local marathonModeButton = state.mainmenu.gui:button('Multiplayer Mode', {x = 100, y = 410, w = 256, h = gui.style.unit*4}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
				marathonModeButton.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
					state.mainmenu.gui:feedback("Multiplayer Mode Selected")
					menu_dialog = false
					multiplayer_menu = true
				end
				]]
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
			end, -- draws gui
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
				end -- draws background
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
				end -- draws smaller image
				list:draw() -- draws list
			end,
			load = function()

				images = { -- declare array for images
					bg = {},
					overlay = {}
				}
				maps = {}
				local tlist={
					x=800, y=0,
					font=love.graphics.setNewFont(ffont, 24),
					rounded=false,
					bordercolor={60,60,60}, -- border color RGB (table)
					selectedcolor={255,255,255}, -- selected color RGB (table)
					fselectedcolor={0,0,0}, -- font selected color RGB (table)
					bgcolor={60,60,60},
					w=480,h=720,showindex=true,
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
				if files then -- for all specified file types in dir
					for i, mus in ipairs(files) do
						mus=dir.."/"..mus
						list:additem(list:getfilename(mus),list:getfileext(mus))
					end
				end
				function love.keypressed(key) -- all key presses check
					if multiplayer_menu then
						if multiplayer_menu then
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
						end
					end
					if story_mode_select_menu then
						if key == "escape" then
							menu_dialog = true
							story_mode_select_menu = false
							love.audio.stop()
						end
					end
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
							source = love.audio.newSource("songs/audio/"..list:getfusion(listselected), "stream") -- play song
							love.audio.play(source)
							source:play()
							mduration=source:getDuration(unit)
							mlistselected = listselected
							freemode_menu = false
							game_dialog = true
							if maps[currentFileNameWoExt].metadata.offset ~=  nil then -- offset for song
								BPMtoDTCount = 0 - maps[currentFileNameWoExt].metadata.offset
							else
								BPMtoDTCount = 0
							end
						end
						if key == "escape" then -- leave select menu
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
				multiplayer = { -- not implmeneted
					gui = gui(),
					update = function(dt)

					end,
					draw = function()

					end,
					load = function()

					end,
				},
				multiplayermenu = { -- not implemented
					gui = gui(),
					update = function(dt)
						state.freemode_menu.update(dt)
					end,
					draw = function()
						state.freemode_menu.draw()
						love.graphics.print("multiplayer menu testo",100,100)
					end,
					load = function()
						state.freemode_menu.load()
						--multiplayerServerIP()
					end,
				},
				score_show={
					gui = gui(),
					update = function(dt)
						state.score_show.gui:update(dt)

					end,
					draw = function()
						state.score_show.gui:draw()
						-- ui for score
						if images["bg"][currentFileNameWoExt] ~= nil then
							if love.filesystem.exists("songs/img/"..currentFileNameWoExt.."/bg.png") then
								love.graphics.draw(images["bg"][currentFileNameWoExt], 0, 0, 0,(1280/images["bg"][currentFileNameWoExt]:getWidth()),720/(images["bg"][currentFileNameWoExt]:getHeight()))
							else
								love.graphics.draw(backgroundImage, 0, 0, r, 1, 1, ox, oy, kx, ky)
							end
						else
							love.graphics.draw(backgroundImage, 0, 0, r, 1, 1, ox, oy, kx, ky)
						end
						love.graphics.setNewFont(ffont,24)
						love.graphics.printf("Song "..currentFileNameWoExt.." cleared!", 100,150,9999)
						love.graphics.printf('scoreTableText', 100,100,999)
						love.graphics.setNewFont(ffontbold,24)
						love.graphics.printf("Final Score: "..finalScore..'%', 100,200,9999)
					end,
					load = function()
						local scoreTableText = ''
						backgroundImage = love.graphics.newImage("assets/img/"..randomNumber.. ".png")
						--scoring system
						local a = #maps[currentFileNameWoExt].chart
						local b = mduration
						maxScore = a*2*100 + b
						local rank = score/maxScore * 100
						finalScore = round(rank,2) -- rando scoring system
						--[[
						highScoreTable = {123412}
						local str = binser.serialize(highScoreTable)
						love.filesystem.write('profile.txt', str)
						if love.filesystem.exists( 'profiles/profile.txt' ) then
							save = love.filesystem.load( 'profiles/profile.txt' )
						end
						local highScoreTable = binser.deserialize(save)
						table.insert(highScoreTable, score)
						local str = binser.serialize(highScoreTable)
						love.filesystem.write('profiles/profile.txt', str)
						--add highscore here
						--put things in here to get player name

						input = gui:input('Chat', {64, love.graphics.getHeight() - 32, 256, gui.style.unit})
						input.keydelay = 500 -- these two are set by default for input elements, same as doing love.setKeyRepeat(element.keydelay, element.keyrepeat) but Gspot will return to current keyrepeat state when it loses focus
						input.keyrepeat = 200 -- keyrepeat is used as default keydelay value if not assigned as above. use element.keyrepeat = false to disable repeating
						input.done = function(this) -- Gspot calls element:done() when you hit enter while element has focus. override this behaviour with element.done = false
						gui:feedback('I say '..this.value)
						this.value = ''
						this.Gspot:unfocus()
					end
					]]
				end,
			},
			story_mode_select = {
				gui = gui(),
				update = function(dt)
					state.common.gui:update(dt)
					state.story_mode_select.gui:update(dt)
					--update the state
				end,
				draw = function()
					love.graphics.draw(backgroundImage, 0, 0, r, 1, 1, ox, oy, kx, ky)
					state.story_mode_select.gui:draw()
					love.graphics.draw(group1, 116, 66, 0, 0.9, 0.9)
					love.graphics.draw(group2, 472, 66, 0, 0.9, 0.9)
					love.graphics.draw(group3, 828, 66, 0, 0.9, 0.9)
					love.graphics.draw(group4, 116, 422, 0, 0.9, 0.9)
					love.graphics.draw(group5, 472, 422, 0, 0.9, 0.9)
					love.graphics.draw(group6, 828, 422, 0, 0.9, 0.9)
					-- draw buttons on screen

				end,
				load = function()
					function playGroupSong() -- beginning of first song in group
						if love.filesystem.exists("songs/maps/"..currentFileNameWoExt..".txt") then
							chunk = love.filesystem.load("songs/maps/"..currentFileNameWoExt..".txt" ) -- load the chunk
							result = chunk() -- execute the chunk
							currentSongBPM = maps[currentFileNameWoExt].metadata.BPM
						else
							love.window.showMessageBox("Error", "No Data Found")
						end
						love.audio.stop()
						source = love.audio.newSource("songs/audio/"..currentFileNameWoExt..".mp3", "stream")
						love.audio.play(source)
						source:play()
						if maps[currentFileNameWoExt].metadata.offset ~=  nil then -- implement offset for charting
							BPMtoDTCount = 0 - maps[currentFileNameWoExt].metadata.offset
						else BPMtoDTCount = 0 end
						mduration=source:getDuration(unit)
						story_mode_select_menu = false
						game_dialog = true -- reset vars
						for i = 1, #group[loadedGroup].dialogs[storyCurrentSong], 1 do
							print(group[loadedGroup].dialogs[storyCurrentSong][i])
							dialogue(group[loadedGroup].dialogs[storyCurrentSong][i]) -- runs dialog
						end

					end
					storyCurrentSong = 1 -- all the buttons for the group menu
					group1 = love.graphics.newImage("assets/groups/group1.png")
					local group1Button = state.story_mode_select.gui:button('', {x = 100, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group1Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Story Mode Selected")
						loadedGroup = 1
						currentFileNameWoExt = group[loadedGroup].song[1]
						playGroupSong() -- changes loaded group, and song name, and starts song
					end
					group2 = love.graphics.newImage("assets/groups/group2.png")

					local group2Button = state.story_mode_select.gui:button('Group 2', {x = 456, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group2Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Free Mode Selected")
						loadedGroup = 2
						currentFileNameWoExt = group[loadedGroup].song[1]

					end
					group3 = love.graphics.newImage("assets/groups/group3.png")

					local group3Button = state.story_mode_select.gui:button('Group 3', {x = 812, y = 50, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group3Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Marathon Mode Selected")
						loadedGroup = 3
						currentFileNameWoExt = group[loadedGroup].song[1]

					end
					group4 = love.graphics.newImage("assets/groups/group4.png")

					local group4Button = state.story_mode_select.gui:button('Group 4', {x = 100, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group4Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Story Mode Selected")
						loadedGroup = 4
						currentFileNameWoExt = group[loadedGroup].song[1]

					end
					group5 = love.graphics.newImage("assets/groups/group5.png")

					local group5Button = state.story_mode_select.gui:button('Group 5', {x = 456, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group5Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Free Mode Selected")
						loadedGroup = 5
						currentFileNameWoExt = group[loadedGroup].song[1]

					end
					group6 = love.graphics.newImage("assets/groups/group6.png")

					local group6Button = state.story_mode_select.gui:button('Group 6', {x = 812, y = 406, w = 256, h = 256}) -- a button(label, pos, optional parent) gui.style.unit is a standard gui unit (default 16), used to keep the interface tidy
					group6Button.click = function(this, x, y) -- set element:click() to make it respond to gui's click event
						state.story_mode_select.gui:feedback("Marathon Mode Selected")
						loadedGroup = 6
						currentFileNameWoExt = group[loadedGroup].song[1]

					end
					blacksquare = love.graphics.newImage("assets/black.png")
				end,
			},
			game_play = {
				gui = gui(),
				update = function(dt)
					BPMtoDTCount = BPMtoDTCount + dt
					halfBPMtoDTCount = halfBPMtoDTCount + dt
					if source and source:isPlaying() then
						mpos=source:tell(unit)
					end
					if mpos + 1 > mduration then
						if not story_mode  then -- if free mode
							love.audio.stop()
							game_dialog = false
							game_over_state = true
							state.score_show.load()
							score_show_dialog = true
							print("Song Ended") -- show scores and stuff
						else -- if on story mode
							storyCurrentSong = storyCurrentSong + 1 -- increment story song number
							if storyCurrentSong > #group[loadedGroup].song then -- if last song
								print("song list over")
								love.audio.stop()
								game_dialog = false
								game_over_state = true
								state.score_show.load()
								score_show_dialog = true
							else
								currentFileNameWoExt = group[loadedGroup].song[storyCurrentSong] -- resets song name to use file system
								if love.filesystem.exists("songs/maps/"..currentFileNameWoExt..".txt") then
									chunk = love.filesystem.load("songs/maps/"..currentFileNameWoExt..".txt" ) -- load the chunk
									result = chunk() -- execute the code within file, returning the map and metadata for game
									currentSongBPM = maps[currentFileNameWoExt].metadata.BPM
								else
									love.window.showMessageBox("Error", "No Data Found") -- debug
								end
								love.audio.stop() -- stops any other audio
								source = love.audio.newSource("songs/audio/"..currentFileNameWoExt..".mp3", "stream") -- starts song
								love.audio.play(source)
								print("Story next song") -- debug
								BPMtoDTCount = 0
								ChartLocation = 0 -- reset vars
								enemySpeed = maps[currentFileNameWoExt].metadata.BPM
								mduration=source:getDuration(unit) -- reset vars
								for i = 1, #group[loadedGroup].dialogs[storyCurrentSong], 1 do -- run story dialog
									print(group[loadedGroup].dialogs[storyCurrentSong][i])
									dialogue(group[loadedGroup].dialogs[storyCurrentSong][i])
								end
							end
						end
					end
					if halfBPMtoDTCount > 30/currentSongBPM then
						halfBPMtoDTCount = 0
						if currentHalfBeat % 2 == 0 then -- check if half beat
							if maps[currentFileNameWoExt].charthalf[ChartLocation] ~= nil then
								maps[currentFileNameWoExt].charthalf[ChartLocation]() -- checks if code exists then executes it, see chart file to look
							else
								--print("no half chart for this Beat") -- debug
							end
							-- print("HalfBeat", ChartLocation)
						end
						currentHalfBeat = currentHalfBeat + 1
					end
					if BPMtoDTCount > 60/currentSongBPM then
						BPMtoDTCount = 0
						-- every beat of the song execute code from the loaded text file
						if maps[currentFileNameWoExt].chart[ChartLocation] ~= nil then
							maps[currentFileNameWoExt].chart[ChartLocation]() -- checks if code exists then executes it, see chart file to look
						else
							--print("no chart for this Beat") -- debug
						end
						-- print("Beat",ChartLocation) -- shows beat and counter
						ChartLocation = ChartLocation + 1 -- increment
					end
				end,
				draw = function()

				end,
				load = function()
					-- this section resets variables on load
					BPMtoDTCount = 0
					ChartLocation = 0
					halfBPMtoDTCount = 0
					currentHalfBeat = 0
				end,
			}
		}

	end

	-- functoins for free mode
