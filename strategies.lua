require "actions"
require "gamestate"
require "mlstate"


function printControllerState(file, buttons)
	file:write(buttons["left"] and 1 or 0, ",")
	file:write(buttons["right"] and 1 or 0, ",")
	file:write(buttons["A"] and 1 or 0, ",")
end

-- enter the game
function enterGame()
	while((getMode() ~= GAME_MODE_STARTING) and (getMode() ~= GAME_MODE_PLAYING)) do
		joypad.write(1, startAction());
		emu.frameadvance();
		joypad.write(1, noAction());
		-- print(getMode());
		emu.frameadvance();
	end
	while (getMode() ~= GAME_MODE_PLAYING) do
		emu.frameadvance();
	end
end

function playRandomGame()

	print("Playing game with random controller. Logging to dr_mario.csv")

	log = io.open("dr_mario.csv", "w+");
	log:write("frame,mode,score,action\n");

	while(true) do
		button_state = getRandomButtonPressAction();
		joypad.write(1, button_state);
		score = getScore();

		log:write(emu.framecount(), ",");
		log:write(getMode(), ",");
		log:write(score, ",");
		log:write(getNameOfAction(button_state));
		log:write("\n");
		log:flush();

		print(getRelativeStateAsArray())

		emu.frameadvance();
	end
end

function playSarsaGame(learning_rate, discount_rate)

	print("Playing game with SARSA learning. Logging to dr_mario.csv")

	log = io.open("dr_mario.csv", "w+");
	log:write("episode,frame,mode,score,action\n");

	local saved_scores = {}	
	local current_state
	local current_action_name
	local reward
	local next_state
	local next_action_name
	local score_last_frame

	local episode_number = 1

	while(true) do

		enterGame()

		print("Starting episode " .. episode_number)

		while(getMode() == GAME_MODE_PLAYING) do -- TODO: handle end of stage, dying, etc.
			current_state = getRelativeStateAsArray()
			current_action_name = getActionForSarsa(saved_scores, current_state)
			score_last_frame = getScore()

			joypad.write(1, getActionForName(current_action_name))
			emu.frameadvance()

			next_state = getRelativeStateAsArray()
			next_action_name = getActionForSarsa(saved_scores, next_state)
			reward = getScore() - score_last_frame - 1 -- -1 to punish it for not learning
			if(getMode() == GAME_MODE_JUST_LOST) then
				reward = -100
				print("Lost a game.");
			elseif(getMode() ~= GAME_MODE_PLAYING) then
				print("NEW GAME MODE DISCOVERED ".. getMode())
			end

			saved_scores = learn_sarsa(current_state, current_action_name, reward, next_state, next_action_name, learning_rate, discount_rate, saved_scores)		

			log:write(episode_number, emu.framecount(), ",", getMode(), ",", getScore(), ",", current_action_name, "\n")
		end

		print("Episode done. Score " .. getScore())

		episode_number = episode_number + 1

	end
end

function getActionForSarsa(saved_scores, state)
	return getBestActionAndScoreForState(saved_scores, state) or getRandomActionNameForSarsa()
end