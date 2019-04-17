local Wall = Base:extend()

function Wall:constructor()
  self.x = 0
  self.y = 0
  self.w = 0
  self.h = 0
  self.active = true
end

function Wall:receive(wall)
  self.x = wall.x
  self.y = wall.y
  self.w = wall.w
  self.h = wall.h
  self.active = wall.active
end


function Wall:draw()
  if self.active then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(0.5, 0.5, 0.5)
  end

  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Wall
