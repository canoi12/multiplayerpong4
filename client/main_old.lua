Base = require "libs.knife.base"
local sock = require "libs.sock"

status = {
	waiting = 1,
	starting = 2,
	playing = 3,
	win = 4
}

player = {
	x = 0,
	y = 0,
	w = 8,
	h = 8
}

local speed = 100

players = {}
ball = nil
walls = {}
game = {
	status = false
}

function love.load()
	client = sock.newClient("localhost", 8080)


	client:connect()

	client:on("connect", function(data)
		print("Client connected to the server")
	end)

	client:on("disconnect", function(data)
		print("Client disconnected from server")
	end)


	client:on("hello", function(msg)
		print("Server replied: " .. msg)
	end)

	client:on("position", function(data)
		players = data
	end)

	client:on("ball_pos", function(data)
		ball = data
	end)

	client:on("wall", function(data) 
		walls = data
	end)

	client:on("status", function(data)
		game.status = data
	end)
end

function love.update(dt)
	client:update()
	if game.status == status.playing then
		if love.keyboard.isDown("left") then
			local aux = -1 * dt
			client:send("move", -speed * dt)
		elseif love.keyboard.isDown("right") then
			local aux = 1 * dt
			client:send("move", speed * dt)
    else
      client:send("move", 0)
		end
	end
end

function love.draw()
	if client:isConnected() then
		love.graphics.print("Aeeeeee", 0, 0)
	else
		love.graphics.print("Ma q caraio, viu?", 4, 4)
	end

	if game.status == status.waiting then
		love.graphics.print("Waiting for players", 240, 240)
	end

	for i,player in ipairs(players) do
		if player.active then
			love.graphics.setColor(1, 1, 1)
		else
			love.graphics.setColor(0.5, 0.5, 0.5)
		end
		love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(player.score, player.x+(player.w/2)-4, player.y+(player.h/2)-6)
	end
	love.graphics.setColor(1, 1, 1)

	if ball then
		love.graphics.circle("line", ball.x, ball.y, ball.radius)
		love.graphics.rectangle("line", ball.x - ball.radius, ball.y - ball.radius, ball.radius*2, ball.radius*2)
	end

	for i,wall in ipairs(walls) do
		if wall.active then
			love.graphics.setColor(1, 1, 1)
		else
			love.graphics.setColor(0.5, 0.5, 0.5)
		end
		love.graphics.rectangle("fill", wall.x, wall.y, wall.w, wall.h)
	end
	love.graphics.setColor(1, 1, 1)

	if game.status == status.win then
		love.graphics.print("Player wins!!", 240, 240)
	end
end
