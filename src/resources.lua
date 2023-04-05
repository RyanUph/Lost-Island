resources = {}

function resources.load()
    coins = {}

    createCoin(400, 400)
    createCoin(300, 300)
    createCoin(200, 600)
end

function resources.update(dt)
    destroyCoin(dt)
end

function resources.draw()
    for i, coin in ipairs(coins) do
        love.graphics.draw(hud.coin, coin.x, coin.y, nil, 4, 4, 8, 8)
    end
end

-- Functions

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
    table.insert(coins, coin)
end

function destroyCoin(dt)
    for i = #coins, 1, -1 do
        local stick = coins[i]
        if stick.dead == true then
            table.remove(coins, i)
            stick.collider:destroy()
            saveData.coins = saveData.coins + 1
        end
    end
end