local Game ={}

Game.__index = Game

setmetatable(Game, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Game.b = {} --board
for i=1 , 9 do
	Game.b[i] = 0
end 

function Game.new()
  local self = setmetatable({}, Game)
  return self
end

function Game.move(player, pos)	
	if pos > 9 then
		print("move must be less than 9")
		return -1
	elseif pos < 1 then
		print("move must be greater than 0") 
		return -1
	end
	
	if Game.b[pos] == 0 then 
		Game.b[pos] = player
		if Game.won(pos) then
			return 1, Game.b, player
		elseif Game.draw() then
			return 2, Game.b, player
		end 
		return 0, Game.b, player
	else
		print("alread occupied")
		return -1, Game.b, player 
	end
end
function Game.getState()--return the gamestate(base 3) as number(base 10) 
	n = 0
	for i,v in ipairs(Game.b) do 
		n = n+v*math.pow(3, i-1)
	end
	return n
end
function Game.draw()
	for i, v in ipairs(Game.b) do 
		if v == 0 then return false end
	end
	return true
end
function Game.won(pos)
	mod3 = pos%3
	if Game.checkCol(mod3, pos) then
		return true
	elseif Game.checkX(pos) then 
		return true
	elseif Game.checkRow(pos) then 
		return true
	else 
		return false
	end
end
function Game.checkCol(mod3, pos) 
	if mod3 == 0 then 
			mod3 = 3
	end
	for i=mod3, 9, 3 do 
		if Game.b[i] ~= Game.b[pos] then
			return false
		end
	end
	
	return true
end
function Game.checkX(pos)
	s = Game.b[pos]	
	if (s == Game.b[1] and s == Game.b[5] and s == Game.b[9] ) or (s == Game.b[3] and s == Game.b[5] and s == Game.b[7]) then
		return true
	else 
		return false
	end
end
function Game.checkRow(pos)

	n = (math.floor((pos-1)/3)*3)+1
	s = Game.b[pos]	
	for i = n, n+2 do 
		if s ~= Game.b[i] then
			return false
		end
	end
	return true
end
function Game.possibleMoves()
	moves = {}
	for i,v in ipairs(Game.b) do 
		if v == 0 then
			table.insert(moves, i)
		end
	end
	return moves
end

return Game
