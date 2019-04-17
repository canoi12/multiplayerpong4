local Player = require "objects.player"
local Ball = require "objects.ball"
local Wall = require "objects.wall"
local sock = require "libs.sock"

local server = {}

local Game = Base:extend()

local status = {
  waiting = 1,
  starting = 2,
  playing = 3,
  win = 4
}

function Game:constructor()
  self.status = 1
  self.starting_time = 3
  self.winning_time = 3
  self.players = {
    Player(480 - 16 - 8, 240 - 32, 16, 64),
    Player(240 - 32, 8, 64, 16),
    Player(8, 240 - 32, 16, 64),
    Player(240 - 32, 480 - 16 - 8, 64, 16)
  }
  self.ball = Ball()
  self.walls = {
    Wall(480 - 4, 0, 4, 480),
    Wall(0, 0, 480, 4),
    Wall(0, 0, 4, 480),
    Wall(0, 480 - 4, 480, 4)
  }
  self.server = {}
  self.currentPlayer = {}

  self.server = sock.newServer("*", 8080, 4)

  self.server:on("connect", function(data, client)
                   local msg = "Hello from the server"
                   client:send("hello", msg)
  end)

  self.server:on("move", function(speed, client)
                   local index = client:getIndex()
                   local player = self.players[index]
                   if self.status ~= status.playing then
                     speed = 0
                   end
                   player:receiveMessage(index, speed)
  end)
end

function Game:update(dt)
  self.server:update()

  if self.status == status.waiting and #self.server:getClients() == 4 then
    self:resetAll()
    self.status = status.starting
  end

  if self.status == status.starting then
    self.starting_time = self.starting_time - (1 * dt)
    if self.starting_time <= 0 then
      self.status = status.playing
    end
  end

  if self.status == status.win then
    self.winning_time = self.winning_time - (1*dt)
    if self.winning_time <= 0 then
      self:newMatch()
      self.status = status.starting
    end
  end

  if #self.server:getClients() < 4 then
    self.status = status.waiting
    self:resetAll()
  end

  self:playerWins()

  self.currentPlayers = {}

  for i,client in ipairs(self.server:getClients()) do
    self.currentPlayers[client:getIndex()] = self.players[client:getIndex()]
  end
  for i,player in ipairs(self.players) do
    player:update(dt)
  end


  if self.status == status.playing then
    self.ball:update(dt)

    self.ball:checkCollision(self.players, self, self.playerCollision)
    self.ball:checkCollision(self.walls, self, self.wallCollision)
  end


  self.server:sendToAll("position", self.currentPlayers)
  self.server:sendToAll("ballPos", self.ball)
  self.server:sendToAll("wallPos", self.walls)
  self.server:sendToAll("status", self.status)
end

function Game:draw()
  love.graphics.print("Oia que server pica!", 0, 0)

  love.graphics.print(#self.server:getClients() .. "/" .. 4, 0, 32)
end

function Game:resetTime()
  self.starting_time = 3
  self.winning_time = 3
end

function Game:resetAll()
  for i,player in ipairs(self.players) do
    player:resetAll()
  end
  for i,wall in ipairs(self.walls) do
    wall:resetAll()
    --wall.active = true
  end
  self.ball:resetAll()
  self:resetTime()
end

function Game:newMatch()
  for i,player in ipairs(self.players) do
    player:newMatch()
  end
  for i,wall in ipairs(self.walls) do
    wall:resetAll()
    --wall.active = true
  end
  self.ball:resetAll()
  self:resetTime()
end

function Game:playerDeath()
  for i,player in ipairs(self.players) do
    player:resetPosition()
  end
  self.ball:resetAll()

  self.starting_time = 3
end

function Game:playerWins()
  remaining = {}
  for i,player in ipairs(self.players) do
    if player.active then
      table.insert(remaining, i)
    end
  end

  if self.status == status.playing and #remaining <= 1 then
    local player = self.players[remaining[1]]
    player.score = player.score + 1
    self.status = status.win
    return remaining[1]
  end
end

function Game:playerCollision(index, item)
  local aux = math.fmod(index, 2)

  self.ball.x = self.ball.x - self.ball.vx
  self.ball.y = self.ball.y - self.ball.vy
  if item.active then
    if aux == 0 then
      self.ball.vy = -self.ball.vy
    else
      self.ball.vx = -self.ball.vx
    end
  end
end

function Game:wallCollision(index, item)
  self.ball.x = self.ball.x - self.ball.vx
  self.ball.y = self.ball.y - self.ball.vy
  if item.active then
    item.active = false
    self.players[index].active = false
    self:playerDeath()
    self.status = status.starting
  else
    local aux = math.fmod(index, 2)
    if aux == 0 then
      self.ball.vy = -self.ball.vy
    else
      self.ball.vx = -self.ball.vx
    end
  end
end

return Game
