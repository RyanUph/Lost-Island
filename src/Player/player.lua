require('libraries/anim8')
player = {}

function player.load()
    player.x = 400
    player.y = 400
    player.itemState = 1
    player.speed = 350
    player.health = 5
    player.spriteSheet = love.graphics.newImage('sprites/Player/player.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-7', 4), 0.13)
    player.animations.up = anim8.newAnimation(player.grid('1-7', 6), 0.13)
    player.animations.right = anim8.newAnimation(player.grid('1-7', 5), 0.13)
    player.animations.left = anim8.newAnimation(player.grid('1-7', 7), 0.13)
    player.animations.attackDown = anim8.newAnimation(player.grid('1-4', 8), 0.07, function() attack = false player.anim = player.animations.down player.anim:gotoFrame(7) end)
    player.animations.attackUp = anim8.newAnimation(player.grid('1-4', 10), 0.07, function() attack = false player.anim = player.animations.up player.anim:gotoFrame(7) end)
    player.animations.attackRight = anim8.newAnimation(player.grid('1-4', 9), 0.07, function() attack = false player.anim = player.animations.right player.anim:gotoFrame(7) end)
    player.animations.attackLeft = anim8.newAnimation(player.grid('1-4', 12), 0.07, function() attack = false player.anim = player.animations.left player.anim:gotoFrame(7) end)
    player.anim = player.animations.down

    facingDown = true
    facingUp = false
    facingRight = false
    facingLeft = false
    attack = false

    player.attackHitBox = {x = player.x, y = player.y + 48, w = 50, h = 50}

    saveData = {}
    saveData.coins = 0
    saveData.stones = 0
    saveData.sticks = 0
end

function player.update(dt)
    playerMovement(dt)
end

function player.draw()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, 4, 24.5, 33)

    if attack then
        love.graphics.rectangle('line', player.attackHitBox.x, player.attackHitBox.y, player.attackHitBox.w, player.attackHitBox.h)
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