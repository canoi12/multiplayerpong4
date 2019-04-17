Base = require "libs.knife.base"
Scene = require "scenes.scene"
Game = require "objects.game"

SceneManager = require "scenemanager"

game = {}

function love.load()
  game = Game()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end
