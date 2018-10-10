INITIAL_SCORE = 0

function learn_sarsa(current_state, current_action, reward, next_state, next_action, learning_rate, future_score_weight, saved_scores)
	current_state_as_str = table.concat(current_state, ",");
	next_state_as_str = table.concat(current_state, ",");

	current_score = getSavedScore(saved_scores, current_state_as_str, current_action, INITIAL_SCORE);
	next_state_score = getSavedScore(saved_scores, next_state_as_str, next_action, INITIAL_SCORE);
	next_score = current_score + learning_rate * (reward + future_score_weight * next_state_score - current_score);

	setSavedScore(saved_scores, state_name, action_name, INITIAL_SCORE)

	return saved_scores -- not necessary, since tables are pass-by-reference, but could be useful
end

function getSavedScore(saved_scores, state_name, action_name, initial_value)
	if (saved_scores[state_name] == nil) then
		setSavedScore(saved_scores, state_name, action_name, initial_value);
	end
	return saved_scores[state_name][action_name];
end

function setSavedScore(saved_scores, state_name, action_name, value)
	if (saved_scores[state_name] == nil) then
		saved_scores[state_name] = {};
	end
	saved_scores[state_name][action_name] = value;
end

-- used for Q learning, and for picking an action
-- returns action, score as a tuple; returns nil, nil if none is set
function getBestActionAndScoreForState(saved_scores, state_name)
	if (saved_scores[state_name] == nil) then -- no scores saved for that state
		return nil, nil;
	end
	max_action, max_score = nil, nil;
	for action, score in saved_scores[state_name] do
		if (max_score == nil or score > max_score) then
			max_action, max_score = action, score;
		end
	end
	return max_action, max_score;
end