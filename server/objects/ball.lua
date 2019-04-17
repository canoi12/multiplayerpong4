local Ball = Base:extend()

function Ball:constructor()
  --[[o = o or {}
  o.radius = 8
  o.speed = 100
    return setmetatable(o, {__index=self})]]
  self.x = 240
  self.y = 240
  self.radius = 8
  self.vx = self:randomize()
  self.vy = self:randomize()
  self.speed = 120
end

function Ball:checkCollision(list, Game, lambda)
  for i, item in ipairs(list) do
    if self.x - self.radius < item.x + item.w and
      self.x + self.radius > item.x and
      self.y - self.radius < item.y + item.h and
      self.y + self.radius > item.y then
      lambda(Game, i, item)
    end
  end
end


function Ball:update(dt)
  self.x = self.x + (self.vx*self.speed*dt)
  self.y = self.y + (self.vy*self.speed*dt)
end

function Ball:resetAll()
  self.x = 240
  self.y = 240
  self.speed = 150
  self.radius = 8
  self.vx = self:randomize()
  self.vy = self:randomize()
end

function Ball:randomize()
  local odd = math.random(-1, 1)
	if odd >= 0 then
		return 1
	else
		return -1
	end
end

return Ball
