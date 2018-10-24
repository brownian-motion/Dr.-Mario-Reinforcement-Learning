
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

	-- Note: may need to catch column 7 + horizontal combination if it becomes a problem
	if (orient == 1) then orient = 'vertical'
	elseif (orient == 2) then orient = 'rev_horizontal'
	elseif (orient == 3) then orient = 'rev_vertical'
	else orient = 'horizontal'
	end
	return (column .. orient)
end

-- action scripts for each placement possibility
function placeCapsule(action)

	local column = action:sub(1,1)
	local orient = string.sub(action, 2)

	if (column == '0') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move left 3 times
		for i=1,3 do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {left = true})
		end
		return
	end

	if (column == '1') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move left 2 times
		for i=1,2 do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {left = true})
		end
		return
	end

	if (column == '2') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move left 1 time
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		joypad.write(1, {left = true})
		return
	end

	if (column == '3') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		return
	end

	if (column == '4') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move right 1 time
		emu.frameadvance()
		emu.frameadvance()
		emu.frameadvance()
		joypad.write(1, {right = true})
		return
	end

	if (column == '5') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move right 2 times
		for i=1,2 do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {right = true})
		end
		return
	end

	if (column == '6') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_horizontal') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move right 3 times
		for i=1,3 do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {right = true})
		end
		return
	end

	if (column == '7') then
		if (orient == 'vertical') then
			joypad.write(1, {A = true})
		end
		if (orient == 'rev_vertical') then
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {A = true})
		end

		-- move right 4 times
		for i=1,4 do
			emu.frameadvance()
			emu.frameadvance()
			emu.frameadvance()
			joypad.write(1, {right = true})
		end
		return
	end
end