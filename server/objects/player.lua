local Player = Base:extend()

function Player:constructor(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.score = 0
  self.vx = 0
  self.vy = 0
  self.speed = 240
  self.active = true
  self.defaults = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  --[[o = {}
  o = {
    x = x,
    y = y,
    w = w,
    h = h,
    score = 0,
    vx = 0,
    vy = 0,
    speed = 180,
    active = true,
    defaults={
      x = x,
      y = y,
      w = w,
      h = h
    }
  }
    return setmetatable(o, {__index=self})]]
end

function Player:receiveMessage(index, speed)
  local aux0 = math.fmod(index, 2)
  local aux1 = math.fmod(index + 1, 2)

  if self.active then
    --self.x = self.x + (speed* aux1)
    --self.y = self.y + (speed * -aux0)
    self.vx = aux1 * speed
    self.vy = -aux0 * speed
  end
end

function Player:update(dt)
  self.x = self.x + (self.vx * self.speed * dt)
  self.y = self.y + (self.vy * self.speed * dt)

  --self.vx = 0
  --self.vy = 0
  if not self.active then
    self.vx = 0
    self.vy = 0
  end

  if self.x < 8 then self.x = 8
  elseif self.x + self.w > 480 - 8 then self.x = 480 - self.w - 8 end

  if self.y < 8 then self.y = 8
  elseif self.y + self.h > 480 - 8 then self.y = 480 - self.h - 8
  end
end

function Player:resetAll()
  self:resetPosition()
  self.active = true
  self.score = 0
end

function Player:resetPosition()
  self.x = self.defaults.x
  self.y = self.defaults.y
  self.w = self.defaults.w
  self.h = self.defaults.h
end

function Player:newMatch()
  self:resetPosition()
  self.active = true
end

return Player
