function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function fspUtil(visMap, tracks, track)
	local x, y = track[#track][1], track[#track][2]

	if x == endX and y == endY then
		table.insert(tracks, deepcopy(track))
		return
	end
	
	visMap[y][x] = "x"

	if y - 1 ~= 0 then
		if visMap[y - 1][x] ~= "0" and visMap[y - 1][x] ~= "x" then
			table.insert(track, {x, y - 1})
			fspUtil(visMap, tracks, track)
			table.remove(track)
		end
	end
	
	if x + 1 ~= #visMap[1] + 1 then 
		if visMap[y][x + 1] ~= "0" and visMap[y][x + 1] ~= "x" then
			table.insert(track, {x + 1, y})
			fspUtil(visMap, tracks, track)
			table.remove(track)
		end
	end
	
	if y + 1 ~= #visMap + 1 then
		if visMap[y + 1][x] ~= "0" and visMap[y + 1][x] ~= "x" then
			table.insert(track, {x, y + 1})
			fspUtil(visMap, tracks, track)
			table.remove(track)

		end
	end
	
	if x - 1 ~= 0 then
		if visMap[y][x - 1] ~= "0" and visMap[y][x - 1] ~= "x" then
			table.insert(track, {x - 1, y})
			fspUtil(visMap, tracks,track)
			table.remove(track)
		end
	end
	visMap[y][x] = " "
end


function findShortPath(maze, x, y)
	
	local visMap = deepcopy(maze)
	local tracks = {}
	local track = {{x, y}}
	
	fspUtil(visMap, tracks, track)
	
	return tracks
end

path = arg[0]:sub(0, -15) .. "Maze.txt"

maze = {}

stX = 0
stY = 0
endX = 0
endY = 0

hIter = 0
wIter = 0

for line in io.lines(path) do
	hIter = hIter + 1
	table.insert(maze, {})
	
	for i = 1, #line do
		local chr = line:sub(i, i)
		wIter = wIter + 1

		if chr == "I" then 
			stX, stY = wIter, hIter
		elseif 
			chr == "E" then endX, endY = wIter, hIter
		end
		
		table.insert(maze[hIter], chr)
	end
	wIter = 0
end

tracks = findShortPath(maze, stX, stY)

table.sort(tracks, function(a, b) return #a < #b end)

for j = 2, #tracks[1] - 1 do
	local x, y = tracks[1][j][1], tracks[1][j][2]
	maze[y][x] = "*"
end

file = io.open(arg[0]:sub(0, -15) .. "output.txt", "w")

for i = 1, #maze do
	for j = 1, #maze[i] do
		file:write(maze[i][j])
	end
	file:write("\n")
end

file:close()