g = require("game")
Learner = require("learner")
l2 = Learner.new(2, 0.3)
l1 = Learner.new(1, 0.3) --player 1 if trained against it self
game = g.new()
player = 1
status, board, rplayer = 0
c = 0
train = 30000
vsHuman = false
vsRandom = true
vsAI = true
history = {}
cHistory = 0


math.randomseed(os.time())
function out(s) 
	if vsHuman == true then 
		print(s)
	else
		--print(s)
		return
	end
end
function outBoard(g)
	local str = ""
	for i, v in ipairs(g) do 
		str = str .. v .. " "	
		if i%3 == 0 then 
			out(str) 
			str = ""
		end
	end
end
function restart()
	for i, v in ipairs(game.b) do
		game.b[i]=0
	end
	player = 1
	c= c+1
	--print(c)
	if c > train then
		vsHuman = true
		print("finished learning")
	end
	eval()
end
function printMoves()
	m=game.possibleMoves()
	s = "Possible Moves: "
	for i,v in ipairs(m) do
		s = s..v.." "
	end
	out(s)
end
function switchPlayer(p)
	if p == 1 then
		return	2
	else
		return	1
	end
end
function eval()
	local lastState = popHistory()
	local currentState = popHistory()
	while(true) do
		print("learning")
		if player == 1 then
			local result = l2:updateValue(lastState, currentState)
			print(result)
			lastState = currentState
			currentState = popHistory()
			
			if currentState == nil then return end

			l1:updateValue(lastState, currentState)
			
			lastState = currentState
			currentState = popHistory()
			if currentState == nil then return end
		else
			local result = l1:updateValue(lastState, currentState)
			print(result)
			lastState = currentState
			currentState = popHistory()
			if currentState == nil then return end
			
			l2:updateValue(lastState, currentState)
			
			lastState = currentState
			currentState = popHistory()
			if currentState == nil then return end
		end
	end
end
function turn()
	local s, b, rp = 0
	updateHistory()
	--TODO update History
	if(player == 1) then
		if vsHuman then	
			s, b, rp = humanAction()
		elseif vsRandom then
			s, b, rp = randomAction() 
		else --vsAI
			s, b, rp = p1AgentAction()
		end
		--l2:updateValue(gameState, game.getState()) 
	else
		s, b, rp = p2AgentAction()
		--sl1:updateValue(gameState, game.getState())
	end
	--TODO update History
	player = switchPlayer(player)
	return s, b, rp
end
function p2AgentAction()
	local aiMove = l2:choose(game.possibleMoves(), game.getState())
	local s, b, rp = game.move(player, aiMove)
	--print("p2 Agent Move " .. aiMove)
	return s, b, rp
end
function p1AgentAction()
	local aiMove = l1:choose(game.possibleMoves(), game.getState())
	local s, b, rp = game.move(player, aiMove)
	--print("p1 Agent Move " .. aiMove)
	return s, b, rp
end
function randomAction()
	local possibleMoves = game.possibleMoves() 
	--print("len: ".. #possibleMoves)
	local ranMove = possibleMoves[math.random(#possibleMoves)]
	local s, b, rp = game.move(player, ranMove)
	return s, b, rp
end
function humanAction()
	local s, b, rp = 0,0,0 
	while(true) do 
		input = tonumber(io.read())
		s, b, rp = game.move(player, input)
		if s ~= -1 then 
			break 
		else
			out("Try something possible!")
		end
	end
	return s, b, rp
end
while(true) do
	gameState = game.getState()
	out("Game number: " .. c)
	out("Game status: " .. status)
	if status == -1 then
		print("ILLIGAL MOVE!!!!")
	end
	out("Game state: " .. gameState)
	out("Player " .. player .. " turn: ")
	out("AI2 score: " .. l2:getValue(gameState))
	printMoves()
	outBoard(game.b)
	status, board, rplayer = turn()
	if status == 1 then 
		out("Player " .. rplayer .. " won the game")
		if(rplayer == 2)then
			l2:setValue(game.getState(), 1.0)
			l1:setValue(game.getState(), 0.0)	
		else
			l2:setValue(game.getState(), 0.0)
			l1:setValue(game.getState(), 1.0)
		end
		print("AI2 score: " .. l2:getValue(game.getState()))
		print("AI1 score: " .. l1:getValue(game.getState()))
		--l2:updateValue(gameState, game.getState())
		--l1:updateValue(gameState, game.getState())
		restart()
	elseif status == 2 then 
		out("Draw!")
		l2:setValue(game.getState(), 1.0)
		l1:setValue(game.getState(), 1.0)
		out("Kein Punkt für Griffendor")
		print("AI2 score: " .. l2:getValue(game.getState()))
		print("AI1 score: " .. l1:getValue(game.getState()))
		--l1:updateValue(gameState, game.getState())
		--l2:updateValue(gameState, game.getState())
		restart()
	end
end


