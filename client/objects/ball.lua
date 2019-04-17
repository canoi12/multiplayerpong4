local Ball = Base:extend()

function Ball:constructor()
  self.x = 240
  self.y = 240
  self.radius = 8
end

function Ball:receive(ball)
  self.x = ball.x
  self.y = ball.y
  self.radius = ball.radius
end

function Ball:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
