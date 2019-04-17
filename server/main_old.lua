local sock = require "libs.sock"
local Ball = require "objects.ball"
local Player = require "objects.player"

ball = Ball:new()
plyers = {
  Player:new(480 - 16 - 8, 240 - 32, 16, 64),
  Player:new(240 - 32, 8, 64, 16),
  Player:new(8, 240 - 32, 16, 64),
  Player:new(240 - 32, 480 - 16 - 8, 64, 16)
}

status = {
	waiting = 1,
	starting = 2,
	playing = 3,
	win = 4
}

defaults = {
	players = {
		{
			x = 480 - 16 - 8,
			y = 240-32,
			w = 16,
			h = 64,
			score = 0,
			active = true
		},
		{
			x = 240 - 32,
			y = 8,
			w = 64,
			h = 16,
			score = 0,
			active = true
		},
		{
			x = 8,
			y = 240 - 32,
			w = 16,
			h = 64,
			score = 0,
			active = true
		},
		{
			x = 240 -32,
			y = 480 - 16 - 8,
			w = 64,
			h = 16,
			score = 0,
			active = true
		}
	},
	ball = {
		x = 200,
		y = 240,
		radius = 8,
		vx = 1,
		vy = 1,
		speed = 100,
		player = nil
	},
	game = {
		starting_time = 3,
		win_time = 3
	}
}

game = {
	status = status.waiting,
	starting_time = 3,
	win_time = 3
}

players = {
	{
		x = 480 - 16 - 8,
		y = 240-32,
		w = 16,
		h = 64,
		score = 0,
		active = true
	},
	{
		x = 240 - 32,
		y = 8,
		w = 64,
		h = 16,
		score = 0,
		active = true
	},
	{
		x = 8,
		y = 240 - 32,
		w = 16,
		h = 64,
		score = 0,
		active = true
	},
	{
		x = 240 -32,
		y = 480 - 16 - 8,
		w = 64,
		h = 16,
		score = 0,
		active = true
	}
}

walls = {
	{
		x = 480-4,
		y = 0,
		w = 4,
		h = 480,
		active = true
	},
	{
		x = 0,
		y = 0,
		w = 480,
		h = 4,
		active = true
	},
	{
		x = 0,
		y = 0,
		w = 4,
		h = 480,
		active = true
	},
	{
		x = 0,
		y = 480 - 4,
		w = 480,
		h = 4,
		active = true
	}
}

--[[ball = {
	x = 200,
	y = 240,
	radius = 8,
	vx = 1,
	vy = 1,
	speed = 150,
	player = nil
  }]]

function ballMovementsRandom()
	local odd = math.random(-1, 1)
	if odd >= 0 then
		return 1
	else
		return -1
	end
end

function isCollidingList(list, lambda)
	for i,item in ipairs(list) do
		if ball.x - ball.radius < item.x + item.w and
			 ball.x + ball.radius > item.x and
			 ball.y - ball.radius < item.y + item.h and
			 ball.y + ball.radius > item.y then

			 --[[local aux = math.fmod(i, 2)
			 if aux == 0 then
			 	--ball.vy = -ball.vy * 0.5 + (math.random(-1, 1)/2)
			 	ball.vy = -ball.vy
			 else
			 	--ball.vx = -ball.vx * 0.5 + (math.random(-1, 1)/2)
			 	ball.vx = -ball.vx
			 end]]
			 lambda(i, item)
	 	end
	end
end

function updateBall(players, walls, dt)
	ball.x = ball.x + (ball.vx*ball.speed*dt)
	ball.y = ball.y + (ball.vy*ball.speed*dt)

	isCollidingList(players, function(index, item)
		local aux = math.fmod(index, 2)
		--ball.speed = ball.speed + 10
		ball.x = ball.x - ball.vx
		ball.y = ball.y - ball.vy
		if item.active then
			ball.player = item
			if (aux == 0) then
				ball.vy = -ball.vy
			else
				ball.vx = -ball.vx
			end
		end
	end)

	isCollidingList(walls, function(index, item)
		ball.x = ball.x - ball.vx
	 	ball.y = ball.y - ball.vy
		if item.active then
			item.active = false
			players[index].active = false
			playerDeath()
			game.status = status.starting
		else
			local aux = math.fmod(index, 2)
			if (aux == 0) then
				ball.vy = -ball.vy
			else
				ball.vx = -ball.vx
			end
		end
	end)

	--[[if (ball.x > 480-8 or ball.x - ball.radius < 0) then
		ball.vx = -ball.vx
	elseif (ball.y > 480-8 or ball.y - ball.radius < 0) then
		ball.vy = -ball.vy
	end]]
end

function resetGame()
	--players = defaults.players
	for i,player in ipairs(players) do
		player.x = defaults.players[i].x
		player.y = defaults.players[i].y
		player.active = true
		player.score = 0
	end

	ball.x = defaults.ball.x
	ball.y = defaults.ball.y
	ball.vx = ballMovementsRandom()
	ball.vy = ballMovementsRandom()
	ball.player = nil

	game.win_time = defaults.game.win_time
	game.starting_time = defaults.game.starting_time

	for i,wall in ipairs(walls) do
		wall.active = true
	end
end

function newMatch()
	for i,player in ipairs(players) do
		player.x = defaults.players[i].x
		player.y = defaults.players[i].y
		player.active = true
	end

	ball.x = defaults.ball.x
	ball.y = defaults.ball.y
	ball.vx = ballMovementsRandom()
	ball.vy = ballMovementsRandom()
	ball.player = nil

	game.win_time = defaults.game.win_time
	game.starting_time = defaults.game.starting_time

	for i,wall in ipairs(walls) do
		wall.active = true
	end
end

function playerDeath()
	--[[for i,player in ipairs(players) do
		if player.active then
			player.x = defaults.players[i].x
			player.y = defaults.players[i].y
		end
	end]]

	ball.x = defaults.ball.x
	ball.y = defaults.ball.y
	ball.vx = ballMovementsRandom()
	ball.vy = ballMovementsRandom()
	ball.player = nil

	game.starting_time = defaults.game.starting_time
end

function playerWins()
	remaining = {}
	for i,player in ipairs(players) do
		if player.active then 
			table.insert(remaining, i)
		end
	end
	if game.status == status.playing and #remaining <= 1 then
		local player = players[remaining[1]]
		player.score = player.score + 1
		game.status = status.win
		return remaining[1]
	end
end

function love.load()
	server = sock.newServer("*", 8080, 4)

	server:on("connect", function (data, client) 
		local msg = "Hello from the server!"
		client:send("hello", msg)
	end)

	server:on("move", function(speed, client)
		local index = client:getIndex()
		local player = players[index]

		local aux0 = math.fmod(index, 2)
		local aux1 = math.fmod(index + 1, 2)

		if player.active then
			player.x = player.x + (speed * aux1)
			player.y = player.y + (speed * aux0 * -1)
		end

		if player.x < 8 then player.x = 8 
		elseif player.x + player.w > 480 - 8 then player.x = 480 - player.w - 8 end

		if player.y < 8 then player.y = 8
		elseif player.y + player.h > 480 - 8 then player.y = 480 - player.h - 8 end
	end)
end

function love.update(dt)
	server:update()
	if game.status == status.waiting and #server:getClients() == 4 then
		resetGame()
		game.status = status.starting
	end

	if game.status == status.starting then
		game.starting_time = game.starting_time - (1*dt)
		if game.starting_time <= 0 then
			game.status = status.playing
		end
	end

	if game.status == status.win then
		game.win_time = game.win_time - (1*dt)
		if game.win_time <= 0 then
			newMatch()
			game.status = status.playing
		end
	end

	if #server:getClients() < 4 then
		game.status = status.waiting
		resetGame()
	end

	playerWins()

	local plys = {}

	for i,client in ipairs(server:getClients()) do
		plys[client:getIndex()] = players[client:getIndex()]
		--table.insert(plys, players[client:getIndex()])
	end

	if game.status == status.playing then
		updateBall(plys, walls, dt)
	end

	server:sendToAll("position", plys)
	server:sendToAll("ball_pos", ball)
	server:sendToAll("wall", walls)
	server:sendToAll("status", game.status)
end

function love.draw()
	love.graphics.print("Oia que server pica!", 0, 0)
end
