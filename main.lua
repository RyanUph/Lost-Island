wf = require('libraries/windfield')
anim8 = require('libraries/anim8')
camera = require('libraries/camera')
require('src/Player/player')
require('src/loadMap')
require('src/resources')
require('src/UI/inventory')
require('src/UI/menu')
require('src/UI/hud')

function love.load()
    -- gameState: 0 = Menu
    -- gameState: 1 = Game
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- System
    cam = camera()
    world = wf.newWorld(0, 0)
    gameState = 0
    gameFont = love.graphics.newFont('fonts/pixel.ttf', 20)
    loadMap('gameMap')
    
    -- Collision classes
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Coin')
    world:addCollisionClass('Player', {ignores = {'Coin'}})

    -- Loading
    player.load()
    menu.load()
    hud.load()
    resources.load()
    inventory.load()

    -- Colliders 
    player.collider = world:newBSGRectangleCollider(400, 500, 40, 75, 5)
    player.collider:setCollisionClass('Player')
    player.collider:setFixedRotation(true)
end

function love.update(dt)
    if gameState == 1 then
        cam:lookAt(player.x, player.y)
        world:update(dt)

        player.update(dt)
        hud.update(dt)
        resources.update(dt)
    end
end

function love.draw()
    if gameState == 1 then
        cam:attach()
            gameMap:drawLayer(gameMap.layers['Grass'])
            gameMap:drawLayer(gameMap.layers['Trees'])
            gameMap:drawLayer(gameMap.layers['Path'])
            gameMap:drawLayer(gameMap.layers['Fences'])
            world:draw()

            player.draw()
            resources.draw()
        cam:detach()

        hud.draw()
        inventory.draw()
    end

    if gameState == 0 then
        menu.draw()
    end
end

-- Functions

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    if key == 'space' and gameState == 0 then gameState = 1 end

    if key == 'e' and player.anim == player.animations.down and not attack and not isMoving then attack = true end
    if key == 'e' and player.anim == player.animations.up and not attack and not isMoving then attack = true end
    if key == 'e' and player.anim == player.animations.right and not attack and not isMoving then attack = true end
    if key == 'e' and player.anim == player.animations.left and not attack and not isMoving then attack = true end

    if key == 'q' then saveData.coins = saveData.coins + 1 end
    if key == 'g' and player.health ~= 0 then player.health = player.health - 1 end
    if key == 'h' then player.health = 5 end

    if key == '1' then player.itemState = 1 end
    if key == '2' then player.itemState = 2 end
    if key == '3' then player.itemState = 3 end
    if key == '4' then player.itemState = 4 end
    if key == '5' then player.itemState = 5 end
    if key == '6' then player.itemState = 6 end
end