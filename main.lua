require "actions"
require "gamestate"

function getRandomButtonState()
	local prob = math.random() * 3.01;
	if(prob < 1) then return leftAction();
	elseif(prob < 2) then return rightAction();
	elseif(prob < 3) then return aAction();
	else return startAction();
	end;
end;


function printState(file, buttons)
	file:write(buttons["left"] and 1 or 0, ",")
	file:write(buttons["right"] and 1 or 0, ",")
	file:write(buttons["A"] and 1 or 0, ",")
	file:write(buttons["start"] and 1 or 0)
end

log = io.open("dr_mario.csv", "w+");
log:write("frame,mode,score,left,right,A,start\n");

while(true) do
	button_state = getRandomButtonState();
	joypad.write(1, button_state);
	score = getScore();

	-- log:write(emu.framecount(), ",");
	-- log:write(getMode(), ",");
	-- log:write(score, ",");
	-- printState(log, joypad.read(1))
	-- log:write("\n");
	-- log:flush();

	print(getStateAsTable())

	emu.frameadvance();
end;


