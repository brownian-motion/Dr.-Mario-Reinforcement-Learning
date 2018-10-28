
function leftAction()
	return {left=true};
end

function rightAction()
	return {right=true};
end

function startAction()
	return {start=true};
end

function aAction()
	return {A=true};
end

function noAction()
	return {};
end

function getNameOfAction(action)
	if (type(action) == "string") then
		return action
	elseif (type(action) == "table") then
		local out = ""
		for k,_ in pairs(action) do
			out = out .. k
		end
		return out
	else
		return "" .. action
	end
end

function getActionForName(action_name)
	local out = {};
	out[action_name] = true; -- only supports a single action
	return out;
end

function getRandomButtonPressAction()
	local prob = math.random() * 4;
	if(prob < 1) then return leftAction();
	elseif(prob < 2) then return rightAction();
	elseif(prob < 3) then return aAction();
	else return noAction();
	end
end

function getRandomActionNameForSarsa()
	return getNameOfAction(getRandomButtonPressAction());
end

function getRandomCapsulePlacement()
	local column = tostring(math.random(8) % 8)
	local orient = math.random(4) % 4

	-- reroll if we get an impossible action
	while ((column == 7) and ((orient == 0) or (orient == 2))) do
		column = tostring(math.random(8) % 8)
		orient = math.random(4) % 4
	end

	if (orient == 1) then orient = 'vertical'
	elseif (orient == 2) then orient = 'rev_horizontal'
	elseif (orient == 3) then orient = 'rev_vertical'
	else orient = 'horizontal'
	end
	return (column .. orient)
end

function getAllCapsulePlacementActions()
	local out = {}
	local actions = {"vertical", "horizontal", "rev_horizontal", "rev_vertical"}
	for col in 1,8 do
		for action in actions do
			out:append(col .. action)
		end
	end
	return out
end

-- action scripts for each placement possibility
function placeCapsule(action)

	local column = tonumber(action:sub(1,1))
	local orient = string.sub(action, 2)
	local goal_orient = 0
	local pill_r, pill_c = getPillRC()

	if (orient == 'vertical') then
		goal_orient = 3
	elseif (orient == 'rev_horizontal') then
		goal_orient = 2
	elseif (orient == 'rev_vertical') then
		goal_orient = 1
	end

	if (((goal_orient == 0) or (goal_orient == 2)) and (column == 7)) then
		column = 6
	end

	while ((getPillOrientation() ~= goal_orient) and (getMode() == GAME_MODE_PLAYING)) do
		joypad.write(1, {A = true})
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
	end

	while ((pill_c > column) and (getMode() == GAME_MODE_PLAYING)) do
		joypad.write(1, {left = true})
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		pill_r, pill_c = getPillRC()
	end

	while ((pill_c < column) and (getMode() == GAME_MODE_PLAYING)) do
		joypad.write(1, {right = true})
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		pill_r, pill_c = getPillRC()
	end
end