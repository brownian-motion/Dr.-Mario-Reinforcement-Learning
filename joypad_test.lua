function getScore()
	return memory.readbyte(0x072A)   + 
	memory.readbyte(0x072B)*10   + 
	memory.readbyte(0x072C)*100  + 
	memory.readbyte(0x072D)*1000 + 
	memory.readbyte(0x072E)*10000;
end;

function getRandomButtonState()
	local prob = math.random() * 3.01;
	if(prob < 1) then return leftAction();
	elseif(prob < 2) then return rightAction();
	elseif(prob < 3) then return aAction();
	else return startAction();
	end;
end;

function leftAction()
	return {left=true};
end;

function rightAction()
	return {right=true};
end;

function startAction()
	return {start=true};
end;

function aAction()
	return {A=true};
end;

function printState(file, buttons)
	file:write(buttons["left"] and 1 or 0, ",")
	file:write(buttons["right"] and 1 or 0, ",")
	file:write(buttons["A"] and 1 or 0, ",")
	file:write(buttons["start"] and 1 or 0)
end

log = io.open("dr_mario.csv", "w+");
log:write("frame,score,left,right,A,start\n");

while(true) do
	button_state = getRandomButtonState();
	joypad.write(1, button_state);
	score = getScore();

	log:write(emu.framecount(), ",");
	log:write(score, ",");
	printState(log, button_state)
	log:write("\n");
	log:flush();

	emu.frameadvance();
end;


