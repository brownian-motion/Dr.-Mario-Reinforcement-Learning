
function getScore()
	return memory.readbyte(0x072A)   + 
	memory.readbyte(0x072B)*10   + 
	memory.readbyte(0x072C)*100  + 
	memory.readbyte(0x072D)*1000 + 
	memory.readbyte(0x072E)*10000;
end;

function getMode()
	return memory.readbyte(0x0046);
end;
