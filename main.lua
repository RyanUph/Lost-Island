wf = require('libraries/windfield')
anim8 = require('libraries/anim8')
camera = require('libraries/camera')
require('src/shop')
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
    
    -- Collision classes
    world:addCollisionClass('NPCDop')
    world:addCollisionClass('NPC')--, {ignores = {'Player'}})
    
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Fire')--, {ignores = {'Player'}})
    world:addCollisionClass('Coin')--, {ignores = {'Player'}})
    world:addCollisionClass('Player', {ignores = {'Coin', 'Fire', 'NPC'}})

    -- Loading
    loadMap('gameMap')
    player.load()
    menu.load()
    hud.load()
    shop.load()
    resources.load()
    inventory.load()

    -- Colliders 
    player.collider = world:newBSGRectangleCollider(400, 500, 40, 75, 5)
    player.collider:setCollisionClass('Player')
    --player.collider:setFilterData(1, bit.band(65535, bit.bnot(2)), 0)
    --player.collider:setCategory(1) -- 1: default
    --player.collider:setMask(2) -- 2: coin
    player.collider:setFixedRotation(true)

    shop.collider = world:newBSGRectangleCollider(shop.x - 85, shop.y - 105, 40, 75, 5)
    shop.collider:setCollisionClass('NPCDop')
    --shop.collider:setCategory(4)
    shop.collider:setType('static')
    shop.collider:setFixedRotation(true)
    shop.colliderDop = world:newCircleCollider(shop.x - 65, shop.y - 60, 100)
    shop.colliderDop:setType('static')
    shop.colliderDop:setCollisionClass('NPC')
    --shop.colliderDop:setCategory(3)

    --shop.colliderDop:setPreSolve(function(c1, c2, contact) contact:setEnabled(false) end)
    
    acc = 0
end

function love.update(dt)
    if gameState == 1 then
        world:update(dt)
        
        player.update(dt)
        hud.update(dt)
        inventory.update(dt)
        resources.update(dt)
        shop.update(dt)
        cam:lookAt(player.x, player.y)
    end
    acc = acc + dt
    if acc > 1 then
        print(gameState)
        --dump(player, "")
        --print(player.state)
        acc = acc - 1
    end
end

local seen={}
local output = ""

function dump(t,i)
	seen[t]=true
	local s={}
	local n=0
	for k in pairs(t) do
		n=n+1 s[n]=k
	end
	table.sort(s)
	for k,v in ipairs(s) do
		output = output .. tostring(i) .. tostring(v) .."\n"
		v=t[v]
		if type(v)=="table" and not seen[v] then
			dump(v,i.."\t")
		end
	end
    return output
end

function love.draw()
    if gameState == 1 then
        cam:attach()
            gameMap:drawLayer(gameMap.layers['Grass'])
            gameMap:drawLayer(gameMap.layers['Trees'])
            gameMap:drawLayer(gameMap.layers['Path'])
            gameMap:drawLayer(gameMap.layers['Fences'])
            world:draw()

            resources.draw()
            player.draw()
            shop.draw()
        cam:detach()

        if isCollided then
            love.graphics.draw(shop.panel, 600, 875, nil, 3, 3)
        end

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
    if key == 'escape' then love.event.quit("lololol") end
    if key == 'space' and gameState == 0 then gameState = 1 end

    if key == '1' then player.itemState = 1 end
    if key == '2' then player.itemState = 2 end
    if key == '3' then player.itemState = 3 end
    if key == '4' then player.itemState = 4 end
    if key == '5' then player.itemState = 5 end
    if key == '6' then player.itemState = 6 end

    if key == 'q' then saveData.coins = saveData.coins + 1 end
    if key == 'g' and player.health ~= 0 then player.health = player.health - 1 end
    if key == 'h' then player.health = 5 end

    if key == 'j' then saveData.healing = saveData.healing + 1 end

    if key == "l" then local result = love.filesystem.write("playerdump.txt", dump(player, ""), all) if not result then print("Failed to write dump file") end end
    
    if key == "p" then
        local mask = player.collider.collision_class 
        print(player.x, player.y, player.collider:getX(), player.collider:getY(), mask)
        for k,v in ipairs(player.collider.world.masks[mask].masks) do
            print(k,v)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and player.itemState == 1 and player.anim == player.animations.down and not attack and not isMoving then attack = true end
    if button == 1 and player.itemState == 1 and player.anim == player.animations.up and not attack and not isMoving then attack = true end
    if button == 1 and player.itemState == 1 and player.anim == player.animations.right and not attack and not isMoving then attack = true end
    if button == 1 and player.itemState == 1 and player.anim == player.animations.left and not attack and not isMoving then attack = true end

    if button == 1 and player.itemState == 6 and saveData.healing > 0 and player.health > 0 then
        player.health = 5 saveData.healing = saveData.healing - 1
    end

    if button == 1 and player.itemState == 2 and isThrowed == false and isMoving == false then throwBoomerang() isThrowed = true end
end