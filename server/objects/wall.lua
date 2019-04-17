local Wall = Base:extend()

function Wall:constructor(x, y, w, h)
  --[[o = {
    x = x,
    y = y,
    w = w,
    h = h,
    active = true
  }
    return setmetatable(o, {__index = self})]]
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.active = true
end

function Wall:resetAll()
  self.active = true
end

return Wall
