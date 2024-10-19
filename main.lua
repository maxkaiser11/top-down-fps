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

	_G.zombies = {}

	_G.bullets = {}

	_G.gameState = 2
	_G.maxTime = 2
	_G.timer = maxTime
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
				gameState = 1
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

	-- Checks collision between bullet and zombie
	for i, z in ipairs(zombies) do
		for j, b in ipairs(bullets) do
			if DistanceBetween(z.x, z.y, b.x, b.y) < 20 then
				z.dead = true
				b.dead = true
			end
		end
	end

	-- removes zombie if dead == true (if collided with a bullet)
	for i = #zombies, 1, -1 do
		local z = zombies[i]
		if z.dead == true then
			table.remove(zombies, i)
		end
	end

	-- removes bullet if dead == true (if bullet collides with a zombie)
	for i = #bullets, 1, -1 do
		local b = bullets[i]
		if b.dead == true then
			table.remove(bullets, i)
		end
	end

	if gameState == 2 then
		timer = timer - dt
		if timer <= 0 then
			SpawnZombie()
			maxTime = 0.95 * maxTime
			timer = maxTime
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
		x = 0,
		y = 0,
		speed = 140,
		dead = false,
	}

	local side = math.random(1, 4)
	if side == 1 then
		zombie.x = -30
		zombie.y = math.random(0, love.graphics.getHeight())
	elseif side == 2 then
		zombie.x = love.graphics.getWidth() + 30
		zombie.y = math.random(0, love.graphics.getHeight())
	elseif side == 3 then
		zombie.x = math.random(0, love.graphics.getWidth())
		zombie.y = -30
	elseif side == 4 then
		zombie.x = math.random(0, love.graphics.getWidth())
		zombie.y = love.graphics.getHeight() + 30
	end

	table.insert(zombies, zombie)
end

function SpawnBullet()
	local bullet = {
		x = player.x,
		y = player.y,
		speed = 500,
		direction = PlayerMouseAngle(),
		dead = false,
	}
	table.insert(bullets, bullet)
end
