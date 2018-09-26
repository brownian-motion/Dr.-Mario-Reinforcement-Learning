
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

function getPillXY()
	return memory.readbyte(0x0305), memory.readbyte(0x0306);
end;

function getPillColors()
	return memory.readbyte(0x0301), memory.readbyte(0x0302);
end;

-- 0-indexed row/col, from top-left
function getPlayFieldTile(row, col)
	if (row < 0 or row >= 16 or col < 0 or col >= 8)
		then return -1;
	else
		return memory.readbyte(0x0400 + 8*row + col)
	end;
end;
