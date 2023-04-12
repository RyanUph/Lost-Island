shop = {}

function shop.load()
    shop.sprite = love.graphics.newImage('sprites/NPC.png')
    shop.panel = love.graphics.newImage('sprites/shop.png')
    shop.x = 400
    shop.y = -100
    isCollided = false
end

function shop.update(dt)
    collideWithThePlayer(dt)
    --print(player.action)
end

function shop.draw()
    love.graphics.draw(shop.sprite, shop.x, shop.y, nil, 4, 4, 24.5, 33)
end

-- Functions

function collideWithThePlayer(dt)
    if shop.colliderDop:enter('Player') then isCollided = true player.action = 1 end
    if shop.colliderDop:exit('Player') then isCollided = false player.action = 0 end
 end