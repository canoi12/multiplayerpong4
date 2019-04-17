local SceneManager = Base:extend()

function SceneManager:constructor()
  self.currentScene = nil
end

function SceneManager:update(dt)
  if self.currentScene ~= nil then
    self.currentScene:update(dt)
  end
end

function SceneManager:draw()
  if self.currentScene ~= nil then
    self.currentScene:draw()
  end
end

function SceneManager:changeScene(scene)
  self.currentScene = scene
end

return SceneManager
