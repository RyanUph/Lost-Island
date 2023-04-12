resources = {}

function resources.load()
    coins = {}
    fires = {}

    createCoin(400, 400)
    createCoin(300, 300)
    createCoin(200, 600)
end

function resources.update(dt)
    destroyResource(dt)
end

function resources.draw()
    for i, coin in ipairs(coins) do
        love.graphics.draw(hud.coin, coin.x, coin.y, nil, 4, 4, 8, 8)
    end
end

-- Functions

function createFire(x, y)
    local fire = {}
    fire.x = x
    fire.y = y
    fire.dead = false
    fire.w = 24
    fire.h = 24
    fire.collider = world:newRectangleCollider(fire.x, fire.y, fire.w, fire.h)
    fire.collider:setType('static')
    fire.collider:setCollisionClass('Fire')
    --fire.collider:setFilterData(3, 65535, 0)
    --fire.collider:setCategory(5) -- 5: fire
    table.insert(fires, fire)
end

function createCoin(x, y)
    local coin = {}
    coin.x = x
    coin.y = y
    coin.dead = false
    coin.w = 24
    coin.h = 24
    coin.collider = world:newRectangleCollider(coin.x - 10, coin.y - 12, coin.w, coin.h)
    coin.collider:setType('static')
    coin.collider:setCollisionClass('Coin')
    --coin.collider:setFilterData(2, 65535, 0)
    --coin.collider:setCategory(2) -- 2: coin
    table.insert(coins, coin)
end

function destroyResource(dt)
    for i, coin in ipairs(coins) do
        if distanceBetween(player.x, player.y, coin.x, coin.y) < 30 then
            coin.dead = true
        end
    end

    for i = #coins, 1, -1 do
        local coin = coins[i]
        if coin.dead == true then
            table.remove(coins, i)
            coin.collider:destroy()
            saveData.coins = saveData.coins + 1
        end
    end
end