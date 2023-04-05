hud = {}

function hud.load()
    hud.panel1 = love.graphics.newImage('sprites/UI/panel1.png')
    hud.panel2 = love.graphics.newImage('sprites/UI/panel2.png')
    hud.coin = love.graphics.newImage('sprites/UI/coin.png')

    -- Hearts
    hud.healthBar0 = love.graphics.newImage('sprites/UI/Hearts/HealthBar0.png') -- 0 HP
    hud.healthBar1 = love.graphics.newImage('sprites/UI/Hearts/HealthBar1.png') -- 5 HP
    hud.healthBar2 = love.graphics.newImage('sprites/UI/Hearts/HealthBar2.png') -- 4 HP
    hud.healthBar3 = love.graphics.newImage('sprites/UI/Hearts/HealthBar3.png') -- 3 HP
    hud.healthBar4 = love.graphics.newImage('sprites/UI/Hearts/HealthBar4.png') -- 2 HP
    hud.healthBar5 = love.graphics.newImage('sprites/UI/Hearts/HealthBar5.png') -- 1 HP
end

function hud.update(dt)
    coinsText = love.graphics.newText(gameFont, tostring(saveData.coins))
end

function hud.draw()
    love.graphics.draw(hud.panel1, 210, 50, nil, 4, 5, 64, 16)
    love.graphics.draw(hud.panel2, 135, 115, nil, 4, 5, 32, 8)

    love.graphics.draw(hud.coin, 50, 116, nil, 5, 5, 8, 8)
    love.graphics.draw(coinsText, 120, 86, nil, 3, 3)

    if player.health == 5 then love.graphics.draw(hud.healthBar1, 210, 56, nil, 5.7, 6, 32, 8) end
    if player.health == 4 then love.graphics.draw(hud.healthBar2, 210, 56, nil, 5.7, 6, 32, 8) end
    if player.health == 3 then love.graphics.draw(hud.healthBar3, 210, 56, nil, 5.7, 6, 32, 8) end
    if player.health == 2 then love.graphics.draw(hud.healthBar4, 210, 56, nil, 5.7, 6, 32, 8) end
    if player.health == 1 then love.graphics.draw(hud.healthBar5, 210, 56, nil, 5.7, 6, 32, 8) end
    if player.health == 0 then love.graphics.draw(hud.healthBar0, 210, 56, nil, 5.7, 6, 32, 8) end
end