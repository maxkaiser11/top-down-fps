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

	bullets = {}

	TempRotation = 0
end

function love.update(dt)
	-- Player Movement
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

	-- Zombie Movement
	for i, z in ipairs(zombies) do
		z.x = z.x + (math.cos(ZombiePlayerAngle(z)) * z.speed * dt)
		z.y = z.y + (math.sin(ZombiePlayerAngle(z)) * z.speed * dt)

		-- Checks Collision
		if DistanceBetween(z.x, z.y, player.x, player.y) < 30 then
			for i, z in ipairs(zombies) do
				zombies[i] = nil
			end
		end
	end

	-- Bullet direction
	for i, b in ipairs(bullets) do
		b.x = b.x + (math.cos(b.direction) * b.speed * dt)
		b.y = b.y + (math.sin(b.direction) * b.speed * dt)
	end

	-- Removing bullet once it exits the screen
	for i = #bullets, 1, -1 do
		local b = bullets[i]
		if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
			table.remove(bullets, i)
		end
	end
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

	for i, b in ipairs(bullets) do
		love.graphics.draw(
			sprites.bullet,
			b.x,
			b.y,
			nil,
			0.4,
			nil,
			sprites.bullet:getWidth() / 2,
			sprites.bullet:getHeight() / 2
		)
	end
end

function love.keypressed(key)
	if key == "space" then
		SpawnZombie()
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		SpawnBullet()
	end
end

function PlayerMouseAngle()
	return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end
function ZombiePlayerAngle(enemy)
	return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function DistanceBetween(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function SpawnZombie()
	local zombie = {
		x = math.random(0, love.graphics.getWidth()),
		y = math.random(0, love.graphics.getHeight()),
		speed = 140,
	}
	table.insert(zombies, zombie)
end

function SpawnBullet()
	local bullet = {
		x = player.x,
		y = player.y,
		speed = 500,
		direction = PlayerMouseAngle(),
	}
	table.insert(bullets, bullet)
end
