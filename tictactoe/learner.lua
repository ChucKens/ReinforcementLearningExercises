local Learner = {}
Learner.defaultVal = 0.5
Learner.__index = Learner

setmetatable(Learner, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
}) 
function Learner.new(p, learnrate)
	local self = setmetatable({}, Learner)
	self.player = p
	self.rate = learnrate
	self.v = {}
	self.stack = {}
	self.stackCounter = 0	
	return self
end
function Learner:getValue(s)
	value = self.v[s]
	if value == nil then 
		self.v[s] = Learner.defaultVal
		return Learner.defaultVal
	end
	return value
end
function Learner:setValue(s, value)
	self.v[s] = value
end
function Learner:push(val)
	self.stack[self.stackCounter] = val 
	self.stackCounter = self.stackCounter + 1 
	return val
end

function Learner:pop()
	self.stackCounter = self.stackConter -1
	return self.stack[self.stackCounter]
end
function Learner:updateValue(s, newS)
	--print("AI: ".. self.player)
	--print("Old State Value: " .. self:getValue(s))
	--print("New State Value: " .. self:getValue(newS))	
	--print("Old Value[s]: " .. self.v[s])
	self.v[s] = self:getValue(s) + self.rate * (self:getValue(newS)-self:getValue(s)) 
	return self.v[s]
	--print("New Value[s]: " .. self.v[s])
	--print("-------------------")
end
function Learner:choose(possible, state)
	local maxVal = 0
	local move = possible[1]
	for i,m in ipairs(possible) do 
		local val = self:getValue(state+self.player*math.pow(3, m-1))
		if val > maxVal then 
			maxVal = val
			move = m
		end
	end	
	return move
end

return Learner
