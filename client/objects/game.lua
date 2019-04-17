local sock = require "libs.sock"
local Game = Base:extend()

local MenuScene = require"scenes.menuscene"

local Player = require "objects.player"
local Ball = require "objects.ball"
local Wall = require "objects.wall"


function Game:constructor()
  self.sceneManager = SceneManager()
  self.sceneManager:changeScene(MenuScene())
  --[[self.client = sock.newClient("localhost", 8080)
  self.status = 1
  self.states = {
    waiting = 1,
    starting = 2,
    playing = 3,
    win = 4
  }
  self.ball = Ball()
  self.players = {
    Player(),
    Player(),
    Player(),
    Player()
  }
  self.walls = {
    Wall(),
    Wall(),
    Wall(),
    Wall()
  }

  self.client:connect()

  self.client:on("connect", function(data)
                   print("Client connected to the server")
  end)

  self.client:on("disconnect", function(data)
                   print("Client disconnected from serve")
  end)

  self.client:on("hello",function(msg)
                   print("Server replied: " .. msg)

  end)

  self.client:on("position", function(data)
                   for i,player in ipairs(data) do
                     self.players[i]:receive(player)
                   end
  end)

  self.client:on("ballPos", function(data)
                   self.ball:receive(data)
  end)

  self.client:on("wallPos", function(data)
                   for i,wall in ipairs(data) do
                     self.walls[i]:receive(wall)
                   end
  end)

  self.client:on("status", function(data)
                   self.status = data
    end)]]
end

function Game:update(dt)
  self.sceneManager:update(dt)
  --[[self.client:update()
  if self.status == self.states.playing then
    if love.keyboard.isDown("left") then
      self.client:send("move", -1)
    elseif love.keyboard.isDown("right") then
      self.client:send("move", 1)
    else
      self.client:send("move", 0)
    end
    end]]
end

function Game:draw()
  self.sceneManager:draw()
  --[[if self.client:isConnected() then
    love.graphics.print("Aeeee", 4, 4)
  else
    love.graphics.print("Ma q caraio, viu?", 4, 4)
  end

  if self.status == self.states.waiting then
    love.graphics.print("Waiting for players", 200, 240)
  end

  for i,player in ipairs(self.players) do
    player:draw()
    --love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
  end
  love.graphics.setColor(1, 1, 1)

  if self.ball then
    self.ball:draw()
  end

  for i,wall in ipairs(self.walls) do
    wall:draw()
  end

  if self.status == self.states.win then
    love.graphics.print("Player wins!!", 200, 240)
    end]]
end

return Game
