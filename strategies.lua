require "actions"
require "gamestate"
require "mlstate"
require "drawstate"

function printControllerState(file, buttons)
	file:write(buttons["left"] and 1 or 0, ",")
	file:write(buttons["right"] and 1 or 0, ",")
	file:write(buttons["A"] and 1 or 0, ",")
end

function pressAndRelease(player, joypad_state)
	joypad.write(player, joypad_state);
	emu.frameadvance();
	joypad.write(player, noAction());
	emu.frameadvance();
end

-- enter the game, optionally at the given virus leve1l
function enterGame(starting_virus_level)
	if(starting_virus_level and getMode() ~= GAME_MODE_STARTING and getMode() ~= GAME_MODE_PLAYING) then
		-- get to the options menu
		-- print("Going to the options menu")
		while(getMode() ~= GAME_MODE_OPTIONS) do
			pressAndRelease(1, startAction());
		end

		-- move the "Virus level" cursor to the right level.
		-- this seems to be necessary because directly editing the memory doesn't seem to work
		-- print("Moving the virus level cursor to " .. starting_virus_level)
		while(getVirusLevel() < starting_virus_level) do
			pressAndRelease(1, rightAction())
		end
	end

	-- print("Starting the game")
	while(getMode() ~= GAME_MODE_STARTING)  do
		pressAndRelease(1, startAction());
	end
	while(getMode() ~= GAME_MODE_PLAYING)  do
		joypad.write(1, noAction())
		emu.frameadvance()
	end
end

function playRandomGame(starting_virus_level)

	local filename = os.date("logs/dr_mario_random_%Y_%m_%d_%H_%M.csv")

	print("Playing game with a random controller. Logging to " .. filename)

	local log = io.open(filename, "w+");
	log:write("episode,score\n");
	local episode_number = 1

	while(episode_number <= 1000) do

		enterGame(starting_virus_level or 1)
		print("Starting episode " .. episode_number)

		while(getMode() == GAME_MODE_PLAYING) do -- TODO: handle end of stage, dying, etc.
			button_state = getRandomButtonPressAction();
			joypad.write(1, button_state);
			emu.frameadvance()

			if(getMode() == GAME_MODE_JUST_LOST) then
				print("Lost a game.");
			elseif(getMode() ~= GAME_MODE_PLAYING) then
				print("NEW GAME MODE DISCOVERED ".. getMode())
			end
		end

		print("Episode done. Score " .. getScore())

		log:write(episode_number, ",", getScore(), "\n")
		log:flush()

		episode_number = episode_number + 1
	end
end

function playSarsaGame(learning_rate, discount_rate, starting_virus_level)

	local filename = os.date("logs/dr_mario_sarsa_%Y_%m_%d_%H_%M.csv")

	print("Playing game with SARSA learning. Logging to " .. filename)

	log = io.open(filename, "w+");
	log:write("episode,score\n");
	--log:write("episode,frame,mode,score,reward,action\n");

	local saved_scores = {}	
	local current_state
	local current_action_name
	local reward
	local next_state
	local next_action_name
	local score_last_frame

	local episode_number = 1

	while(episode_number <= 1000) do

		enterGame(starting_virus_level)

		print("Starting episode " .. episode_number)

		while(getMode() == GAME_MODE_PLAYING) do -- TODO: handle end of stage, dying, etc.
			current_state = getRelativeStateAsArray()
			current_action_name = getActionForSarsa(saved_scores, current_state)
			score_last_frame = getScore()

			drawBoxAroundPill()
			joypad.write(1, getActionForName(current_action_name))
			emu.frameadvance()

			next_state = getRelativeStateAsArray()
			next_action_name = getActionForSarsa(saved_scores, next_state)
			reward = 1000*(getScore() - score_last_frame) - 1 -- -1 to punish it for not learning
			if(getMode() == GAME_MODE_JUST_LOST) then
				reward = -50
				print("Lost a game.");
			elseif(getMode() ~= GAME_MODE_PLAYING) then
				print("NEW GAME MODE DISCOVERED ".. getMode())
			end

			saved_scores = learn_sarsa(current_state, current_action_name, reward, next_state, next_action_name, learning_rate, discount_rate, saved_scores)		

			--log:write(episode_number, ",", emu.framecount(), ",", getMode(), ",", getScore(), ",", reward, ",", current_action_name, "\n")
		end

		print("Episode done. Score " .. getScore())
		log:write(episode_number, ",", getScore(), "\n")
		log:flush()

		episode_number = episode_number + 1

	end
end

function getActionForSarsa(saved_scores, state)
	return getBestActionAndScoreForState(saved_scores, state) or getRandomActionNameForSarsa()
end


function drawBoxAroundPill()
	local r, c = getPillRC()
	local state = getRelativeStateAsTable()
	drawBoxAroundTiles(r, c - SEARCH_DIST_BESIDE, r - SEARCH_DIST_BELOW, c + SEARCH_DIST_BESIDE)
	for col_offset = -SEARCH_DIST_BESIDE, SEARCH_DIST_BESIDE do
		local highest = state.grid[col_offset]
		
		local color;
		if(highest.match_color == MATCHES_LEFT) then
			color = "#00FF0077"
		elseif(highest.match_color == MATCHES_RIGHT) then
			color = "#00FFFF77"
		elseif(highest.match_color == MATCHES_BOTH) then
			color = "#FFFFFF77"
		else 
			color = "#88777777"
		end
		-- local color = highest.is_virus and "#FF000077" or "#00FFFF77"
		drawBoxAroundTile(r - highest.dist_below, c + col_offset, color);
	end
end

function playQLearning(learning_rate, discount_rate, strategy)

	local filename = os.date("logs/dr_mario_Q_%Y_%m_%d_%H_%M.csv")

	print("Playing game with Q learning. Logging to " .. filename)

	log = io.open(filename, "w+");
	log:write("episode,score\n");

	local saved_scores = {}	
	local current_state
	local current_action_name
	local reward
	local next_state
	--local next_action_name
	local score_last_frame

	local episode_number = 1

	while(episode_number <= 1000) do

		enterGame(5)

		print("Starting episode " .. episode_number)

		if (strategy == 'scripted') then
			while (strategy == 'scripted' and getMode() == GAME_MODE_PLAYING) do
				current_state = getHighestMatchingArray()
				current_action_name = getBestScriptForQ(saved_scores, current_state)
				score_last_frame = getScore()

				placeCapsule(current_action_name)

				print("Current action " .. current_action_name)
				-- advance some frames to allow the capsule to move
				while ((getPillRC() == 15) and (getMode() == GAME_MODE_PLAYING)) do
					emu.frameadvance()
					emu.frameadvance()
					emu.frameadvance()
				end

				-- wait for the next capsule to drop
				-- this ensures any score changes have happened
				while ((getPillRC() ~= 15) and (getMode() == GAME_MODE_PLAYING)) do
					for i = 1, 10 do
						emu.frameadvance()
					end
				end

				--next_state = getRelativeStateAsArray()
				next_state = getHighestMatchingArray()
				--print(next_state)

				reward = (getScore() - score_last_frame)*1000 - 1 -- -1 to punish it for not learning
				if(getMode() == GAME_MODE_JUST_LOST) then
					reward = -50
					print("Lost a game.");
				elseif(getMode() ~= GAME_MODE_PLAYING) then
					print("NEW GAME MODE DISCOVERED ".. getMode())
				end

				saved_scores = qlearn(current_state, current_action_name, reward, learning_rate, discount_rate, saved_scores, next_state, strategy)	
				--log:write(episode_number, ",", emu.framecount(), ",", getMode(), ",", getScore(), ",", reward, ",", current_action_name, "\n")
			end

		else
			while(getMode() == GAME_MODE_PLAYING) do -- TODO: handle end of stage, dying, etc.
				current_state = getRelativeStateAsArray()
				current_action_name = getBestActionForQ(saved_scores, current_state)
				score_last_frame = getScore()

				drawBoxAroundPill()
				joypad.write(1, getActionForName(current_action_name))
				emu.frameadvance()

				next_state = getRelativeStateAsArray()
				--next_action_name = getBestActionForQ(saved_scores, next_state)
				reward = (getScore() - score_last_frame)*1000 - 1 -- -1 to punish it for not learning
				if(getMode() == GAME_MODE_JUST_LOST) then
					reward = -50
					print("Lost a game.");
				elseif(getMode() ~= GAME_MODE_PLAYING) then
					print("NEW GAME MODE DISCOVERED ".. getMode())
				end

				saved_scores = qlearn(current_state, current_action_name, reward, learning_rate, discount_rate, saved_scores, next_state, strategy)		

				--log:write(episode_number, ",", emu.framecount(), ",", getMode(), ",", getScore(), ",", reward, ",", current_action_name, "\n")
			end
		end

		print("Episode done. Score " .. getScore())
		log:write(episode_number, ",", getScore(), "\n")
		flog:flush()
		episode_number = episode_number + 1

	end
end

function getBestActionForQ(saved_scores, state)
	return getBestActionAndScoreForState(saved_scores, state) or getRandomActionNameForSarsa()
end

function getBestScriptForQ(saved_scores, state)
	return getBestActionAndScoreForState(saved_scores, state) or getRandomCapsulePlacement()
end

function testScripts()
	enterGame()

	while (getMode() == GAME_MODE_PLAYING) do
		placeCapsule('6rev_vertical')

		while ((getPillRC() == 15) and (getMode() == GAME_MODE_PLAYING)) do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
		end
	
		-- wait for the next capsule to drop
		-- this ensures any score changes have happened
		while ((getPillRC() ~= 15) and (getMode() == GAME_MODE_PLAYING)) do
			for i = 1, 10 do
				emu.frameadvance()
			end
		end
	end
end