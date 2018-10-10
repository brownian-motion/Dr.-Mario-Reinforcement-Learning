HIGHEST_ROW = 0
LOWEST_ROW = 15
LEFTMOST_COL = 0
RIGHTMOST_COL = 7

MATCHES_NONE = 0
MATCHES_LEFT = 1
MATCHES_RIGHT = 2
MATCHES_BOTH = MATCHES_LEFT -- to keep state space down; setting to 3 would allow for decisions to utilize both identical sides

PILL_HORIZ = 0
PILL_VERT = 1

SEARCH_DIST_BELOW = 5
SEARCH_DIST_BESIDE = 2


GAME_MODE_MENU = 255
GAME_MODE_STARTING = 8
GAME_MODE_PLAYING = 4
GAME_MODE_GAME_OVER = 7

function getScore()
	return memory.readbyte(0x072A)   + 
	memory.readbyte(0x072B)*10   + 
	memory.readbyte(0x072C)*100  + 
	memory.readbyte(0x072D)*1000 + 
	memory.readbyte(0x072E)*10000
end

function getMode()
	return memory.readbyte(0x0046)
end

-- x,y = getPillRC()
function getPillRC()
	return memory.readbyte(0x0306), memory.readbyte(0x0305)
end

-- col_left, col_right = getPillColors()
function getPillColors()
	return memory.readbyte(0x0301), memory.readbyte(0x0302)
end

-- 0-indexed row/col, from top-left
-- col = getPlayFieldTile(0,3) -- top row, 4th-left-most column
function getPlayFieldTile(row, col)
	if (row < 0 or row >= 16 or col < 0 or col >= 8) then
		return -1
	else
		return memory.readbyte(0x0400 + 8*row + col)
	end
end

function getPillOrientation()
	return memory.readbyte(0x00A5)
end

function isVirus(tile_value)
	return tile_value >= 208 or tile_value <= 210
end

function isPellet(tile_value)
	return (not isVirus(tile_value)) and (not isEmpty(tile_value))
end

function isEmpty(tile_value)
	return tile_value == 255
end

-- 0 for yellow, 1 for red, 2 for blue, 3 for empty
function getColor(tile_value)
	return AND(tile_value, 0x3)
end

function getRowOfHighestBlockBelow(row, col)
	if(col < LEFTMOST_COL or col > RIGHTMOST_COL) then
		return HIGHEST_ROW
	end

	for row_offset = 0,(SEARCH_DIST_BELOW-1) do
		if(not isEmpty(row + row_offset, col)) then
			return row + row_offset
		end
	end
	return row + SEARCH_DIST_BELOW
end

function convertColorToMatching(color, pill_left_color, pill_right_color)
	if (color == pill_left_color) then
		if (color == pill_right_color) then
			return MATCHES_BOTH
		else
			return MATCHES_LEFT
		end
	elseif (color == pill_right_color) then
		return MATCHES_RIGHT
	else
		return MATCHES_NONE
	end
end

-- returns table of { left_color = {0,1,2}, right_color = {0,1,2}, orientation = {0,1} }
function getPillState()
	local col_l, col_r = getPillColors()
	local r, c = getPillRC()
	local orient = getPillOrientation()
	if (orient > 2) then
		return { row = r, col = c, left_color = col_r, right_color = col_l, orientation = (orient - 2) }
	else
		return { row = r, col = c, left_color = col_l, right_color = col_r, orientation = orient }
	end
end

function getLocalNeighborhoodBelow(pill_state)
	local highest = {} -- faster access than globals
	for col_offset = -SEARCH_DIST_BESIDE,SEARCH_DIST_BESIDE do
		local row
		local col = pill_state.col + col_offset

		if (col_offset == 0 or (col_offset == 1 and pill_state.orient == PILL_HORIZ)) then -- avoid reading the pill itself
			row = getRowOfHighestBlockBelow(pill_state.row + 1, col)
		else
			row = getRowOfHighestBlockBelow(pill_state.row, col)
		end

		local dist_below = row - pill_state.row
		local tile_value = getPlayFieldTile(row, col)
		local color = getColor(tile_value)
		local is_virus = isVirus(tile_value)
		local match_color = convertColorToMatching(color, pill_state.left_color, pill_state.right_color)
		highest[col_offset] = { dist_below = dist_below, is_virus = is_virus, match_color = match_color }
	end
	return highest
end

function getStateAsTable()
	local pill_state = getPillState();
	return {
		pill_orientation = pill_state.orientation,
		grid             = getLocalNeighborhoodBelow(pill_state)
	}
end

function convertStateToArray(state)
	local state_arr = { }
	local i = 1 -- arrays start at 1
	for col_offset = -SEARCH_DIST_BESIDE,SEARCH_DIST_BESIDE do
		local highest = state.grid[col_offset]
		state_arr[i] = highest.dist_below; i = i + 1
		state_arr[i] = highest.is_virus; i = i + 1
		state_arr[i] = highest.match_color; i = i + 1
	end
	state_arr[i] = state.pill_orientation
	return state_arr;
end

function getStateAsArray()
	return convertStateToArray(getStateAsTable())
end