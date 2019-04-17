Base = require "libs.knife.base"
local sock = require "libs.sock"
local game = require "objects.game"

local Game = {}


function love.load()
  --server = sock.newServer("*", 8080, 4)
  Game = game()
end

function love.update(dt)
  Game:update(dt)
end

function love.draw()
  Game:draw()
end
