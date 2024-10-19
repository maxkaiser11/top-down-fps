local love = require("love")

function love.load()
	_G.sprites = {
		background = love.graphics.newImage("sprites/background.png"),
		bullet = love.graphics.newImage("sprites/bullet.png"),
		player = love.graphics.newImage("sprites/player.png"),
		zombie = love.graphics.newImage("sprites/zombie.png"),
	}

	_G.player = {
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		speed = 180,
	}

	zombies = {}

	TempRotation = 0
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

	TempRotation = TempRotation + 0.01
end

function love.draw()
	love.graphics.draw(sprites.background, 0, 0)
	-- Drawing Player
	love.graphics.draw(
		sprites.player,
		player.x,
		player.y,
		PlayerMouseAngle(),
		nil,
		nil,
		sprites.player:getWidth() / 2,
		sprites.player:getHeight() / 2
	)

	for i, z in ipairs(zombies) do
		love.graphics.draw(
			sprites.zombie,
			z.x,
			z.y,
			ZombiePlayerAngle(z),
			nil,
			nil,
			sprites.zombie:getWidth() / 2,
			sprites.zombie:getHeight() / 2
		)
	end
end

function love.keypressed(key)
	if key == "space" then
		SpawnZombie()
	end
end

function PlayerMouseAngle()
	return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end
function ZombiePlayerAngle(enemy)
	return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function SpawnZombie()
	local zombie = {
		x = math.random(0, love.graphics.getWidth()),
		y = math.random(0, love.graphics.getHeight()),
		speed = 100,
	}
	table.insert(zombies, zombie)
end
