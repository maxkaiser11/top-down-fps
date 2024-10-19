local love = require("love")

function love.load()
	_G.sprites = {}
	sprites.background = love.graphics.newImage("sprites/background.png")
	sprites.bullet = love.graphics.newImage("sprites/bullet.png")
	sprites.player = love.graphics.newImage("sprites/player.png")
	sprites.zombie = love.graphics.newImage("sprites/zombie.png")

	_G.player = {}
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.speed = 180
end

function love.update(dt)
	if love.keyboard.isDown("d") then
		player.x = player.x + player.speed * dt
	end

	if love.keyboard.isDown("a") then
		player.x = player.x - player.speed * dt
	end

	if love.keyboard.isDown("w") then
		player.y = player.y - player.speed * dt
	end

	if love.keyboard.isDown("s") then
		player.y = player.y + player.speed * dt
	end
end

function love.draw()
	love.graphics.draw(sprites.background, 0, 0)
	love.graphics.draw(sprites.player, player.x, player.y)
end
