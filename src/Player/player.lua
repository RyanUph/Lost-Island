require('libraries/anim8')
Timer = require('libraries/timer')
player = {}
boomerangs = {}

function player.load()
    player.x = 400
    player.y = 400
    player.damage = 1
    player.itemState = 1
    player.action = 0
    player.speed = 350
    player.health = 5
    player.spriteSheet = love.graphics.newImage('sprites/Player/player.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-7', 4), 0.1)
    player.animations.up = anim8.newAnimation(player.grid('1-7', 6), 0.1)
    player.animations.right = anim8.newAnimation(player.grid('1-7', 5), 0.1)
    player.animations.left = anim8.newAnimation(player.grid('1-7', 7), 0.1)
    player.animations.attackDown = anim8.newAnimation(player.grid('1-4', 8), 0.07, function() attack = false player.anim = player.animations.down player.anim:gotoFrame(7) end)
    player.animations.attackUp = anim8.newAnimation(player.grid('1-4', 10), 0.07, function() attack = false player.anim = player.animations.up player.anim:gotoFrame(7) end)
    player.animations.attackRight = anim8.newAnimation(player.grid('1-4', 9), 0.07, function() attack = false player.anim = player.animations.right player.anim:gotoFrame(7) end)
    player.animations.attackLeft = anim8.newAnimation(player.grid('1-4', 12), 0.07, function() attack = false player.anim = player.animations.left player.anim:gotoFrame(7) end)
    player.anim = player.animations.down

    sprites = {}
    sprites.boomerang = love.graphics.newImage('sprites/Player/boomerang.png')

    facingDown = true
    facingUp = false
    facingRight = false
    facingLeft = false
    attack = false

    player.attackHitBox = {x = player.x, y = player.y + 48, w = 50, h = 50}

    saveData = {}
    saveData.mana = 0
    saveData.healing = 1
    saveData.coins = 0
    saveData.stones = 0
    saveData.sticks = 0

    isThrowed = false
    boomRot = 0
end

function player.update(dt)
    playerMovement(dt)

    Timer.update(dt)

    boomerangTimer(dt)
    boomerangRotation(dt)
    boomerangMovement(dt)
    destroyBoomerang(dt)
end

function player.draw()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, 4, 24.5, 33)

    if attack then
        love.graphics.rectangle('line', player.attackHitBox.x, player.attackHitBox.y, player.attackHitBox.w, player.attackHitBox.h)
    end

    for i, boomerang in ipairs(boomerangs) do
        love.graphics.draw(sprites.boomerang, boomerang.x, boomerang.y, boomRot, 4, 4, 8, 8)
    end
end

-- Functions 

function playerMovement(dt)
    isMoving = false
    dirX = 0
    dirY = 0
    local vX = 0
    local vY = 0

    if love.keyboard.isDown('w') then
        vY = player.speed * -1
        dirY = -1
        if not attack then player.anim = player.animations.up end

        isMoving = true
        facingUp = true
        facingDown = false
        facingRight = false
        facingLeft = false
    end

    if love.keyboard.isDown('s') then
        vY = player.speed
        dirY = 1
        if not attack then player.anim = player.animations.down end

        isMoving = true
        facingUp = false
        facingDown = true
        facingRight = false
        facingLeft = false
    end

    if love.keyboard.isDown('a') then
        vX = player.speed * -1
        dirX = -1
        if not attack then player.anim = player.animations.left end

        isMoving = true
        facingUp = false
        facingDown = false
        facingRight = false
        facingLeft = true
    end

    if love.keyboard.isDown('d') then
        vX = player.speed
        dirX = 1
        if not attack then player.anim = player.animations.right end

        isMoving = true
        facingUp = false
        facingDown = false
        facingRight = true
        facingLeft = false
    end

    if isMoving == false and not attack then
        player.anim:gotoFrame(7)
    end

    if attack then checkCollisionAttack() end

    player.anim:update(dt)
    player.collider:setLinearVelocity(vX, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    if facingRight and attack then player.attackHitBox = {x = player.x + 44, y = player.y - 24, w = 50, h = 50} player.anim = player.animations.attackRight end
    if facingLeft and attack then player.attackHitBox = {x = player.x - 94, y = player.y - 24, w = 50, h = 50} player.anim = player.animations.attackLeft end
    if facingDown and attack then player.attackHitBox = {x = player.x - 24, y = player.y + 48, w = 50, h = 50} player.anim = player.animations.attackDown end
    if facingUp and attack then player.attackHitBox = {x = player.x - 24, y = player.y - 98, w = 50, h = 50} player.anim = player.animations.attackUp end
end

-- Hitbox functions 

function checkHitBox(object)
    if object.x + object.w > player.attackHitBox.x and
    object.y + object.h > player.attackHitBox.y and
    object.x < player.attackHitBox.x + player.attackHitBox.w and
    object.y < player.attackHitBox.y + player.attackHitBox.h then
        return true
    end
end

function checkCollisionAttack()
    for i, coin in ipairs(coins) do
        if checkHitBox(coin) then
            coin.dead = true
        end
    end
end

-- Boomerang functions

function throwBoomerang()
    local boomerang = {}
    boomerang.x = player.x
    boomerang.y = player.y
    boomerang.speed = 500
    boomerang.dead = false
    boomerang.state = 1

    if facingRight then boomerang.direction = 1 end
    if facingLeft then boomerang.direction = 2 end
    if facingDown then boomerang.direction = 3 end
    if facingUp then boomerang.direction = 4 end

    table.insert(boomerangs, boomerang)
end

function destroyBoomerang(dt)
    for i = #boomerangs, 1, -1 do
        local boomerang = boomerangs[i]
        local gx, gy = cam:worldCoords(0, 0)
        local gw, gh = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
        if boomerang.x < gx - 10 or boomerang.y < gy - 10 or boomerang.x > gw + 10 or boomerang.y > gh + 10 then
            table.remove(boomerangs, i)
            isThrowed = false
        end
    end
end

function boomerangRotation(dt)
    if isThrowed == true then
        boomRot = boomRot + 0.1
    end
end

function boomerangTimer(dt)
    if isThrowed then
        for i, boomerang in ipairs(boomerangs) do
            if boomerang.state == 1 then
                Timer.after(1.2, function ()
                boomerang.dead = true
                boomRot = 0
                end)
            end
        end
    end
end

function boomerangMovement(dt)
    for i, boomerang in ipairs(boomerangs) do
        if distanceBetween(player.x, player.y, boomerang.x, boomerang.y) > 300 then
            boomerang.state = 2
        end

        if boomerang.state == 1 and boomerang.direction == 3 then
            boomerang.y = boomerang.y + boomerang.speed * dt
        elseif boomerang.state == 2 and boomerang.direction == 3 then
            boomerang.y = boomerang.y - boomerang.speed * dt
        end

        if boomerang.state == 1 and boomerang.direction == 4 then
            boomerang.y = boomerang.y - boomerang.speed * dt
        elseif boomerang.state == 2 and boomerang.direction == 4 then
            boomerang.y = boomerang.y + boomerang.speed * dt
        end

        if boomerang.state == 1 and boomerang.direction == 1 then
            boomerang.x = boomerang.x + boomerang.speed * dt
        elseif boomerang.state == 2 and boomerang.direction == 1 then
            boomerang.x = boomerang.x - boomerang.speed * dt
        end

        if boomerang.state == 1 and boomerang.direction == 2 then
            boomerang.x = boomerang.x - boomerang.speed * dt
        elseif boomerang.state == 2 and boomerang.direction == 2 then
            boomerang.x = boomerang.x + boomerang.speed * dt
        end

        if boomerang.state == 2 and distanceBetween(player.x, player.y, boomerang.x, boomerang.y) < 30 then
            boomerang.dead = true
            isThrowed = false
        end
    end

    for i = #boomerangs, 1, -1 do
        local boomerang = boomerangs[i]
        if boomerang.dead == true then table.remove(boomerangs, i) isThrowed = false end
    end
end