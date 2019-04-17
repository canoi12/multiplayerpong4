local MenuScene = Scene:extend()

local GameScene = require "scenes.gamescene"

function MenuScene:constructor()
  self.name = "MenuScene"

  self.index = 1

  self.options = {
    "Iniciar",
    "Sair"
  }
end

function MenuScene:update(dt)
  if love.keyboard.isDown("return") then
    if self.index == 1 then
      game.sceneManager:changeScene(GameScene())
    else
      --exit
    end
  end
end

function MenuScene:draw()

  love.graphics.print("Pong 4 Game", 200, 64)

  for i,option in ipairs(self.options) do
    love.graphics.print(option, 200, 128+32*i)
  end
end

return MenuScene
