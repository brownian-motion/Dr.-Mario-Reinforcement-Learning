
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