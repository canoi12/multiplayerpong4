local Player = Base:extend()

function Player:constructor()
  self.x = 0
  self.y = 0
  self.w = 0
  self.h = 0
  self.score = 0
  self.active = true
end

function Player:receive(player)
  self.x = player.x
  self.y = player.y
  self.w = player.w
  self.h = player.h
  self.score = player.score
  self.active = player.active
end

function Player:draw()
  if self.active then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0.5, 0.5, 0.5)
  end

  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(self.score, self.x+(self.w/2)-3, self.y+(self.h/2)-6)
end

return Player
