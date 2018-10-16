require "gamestate"

NUM_PIXELS_IN_ROW = 8
NUM_COLS_TO_LEFT_OF_JAR = 12
NUM_ROWS_ABOVE_JAR = 9

function getTopLeftCornerOfGameTile(row, col)
	local pixels_from_left = (NUM_COLS_TO_LEFT_OF_JAR+col) * NUM_PIXELS_IN_ROW
	local pixels_from_top = (NUM_ROWS_ABOVE_JAR+16-row) * NUM_PIXELS_IN_ROW
	return pixels_from_left, pixels_from_top
end

function getBottomRightCornerOfGameTile(row, col)
	local left, top = getTopLeftCornerOfGameTile(row, col)
	return left+NUM_PIXELS_IN_ROW-1, top+NUM_PIXELS_IN_ROW-1
end

function drawBoxAroundTiles(row1, col1, row2, col2, color)

	-- if(row1 < HIGHEST_ROW) then row1 = HIGHEST_ROW end
	-- if(col1 < LEFTMOST_COL) then col1 = LEFTMOST_COL end
	-- if(row2 > LOWEST_ROW) then row2 = LOWEST_ROW end
	-- if(col2 > RIGHTMOST_COL) then col2 = RIGHTMOST_COL end

	-- if(row1 < row2) then
	-- 	row1, row2 = row2, row1
	-- end

	-- if(col1 > col2) then
	-- 	col1, col2 = col2, col1
	-- end


	local left, top = getTopLeftCornerOfGameTile(row1, col1)
	local right, bottom = getBottomRightCornerOfGameTile(row2, col2)
	gui.drawrect(left, top, right, bottom, color)
	gui.setpixel(left, top, "red")
	gui.setpixel(left+1, top, "red")
	gui.setpixel(left, top+1, "red")
	gui.setpixel(left-1, top, "red")
	gui.setpixel(left, top-1, "red")
	gui.setpixel(right, bottom, "blue")
	gui.setpixel(right+1, bottom, "blue")
	gui.setpixel(right, bottom+1, "blue")
	gui.setpixel(right-1, bottom, "blue")
	gui.setpixel(right, bottom-1, "blue")
end

function drawBoxAroundTile(row, col, color)
	drawBoxAroundTiles(row, col, row, col, color)
end