function getScore()
	return memory.readbyte(0x072A)   + 
	    memory.readbyte(0x072B)*10   + 
	    memory.readbyte(0x072C)*100  + 
	    memory.readbyte(0x072D)*1000 + 
	    memory.readbyte(0x072E)*10000;
end;

function getRandomButtonState()
	local dir_prob = math.random() * 3;
	return {
		left=dir_prob < 1, 
		right=dir_prob >= 1 and dir_prob < 2, 
		A=math.random() < 0.5, 
		start=math.random() < 0.01
	}
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


