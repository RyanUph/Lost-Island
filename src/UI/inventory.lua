inventory = {}

function inventory.load()
    inventory.panel1 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel1.png')
    inventory.panel2 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel2.png')
    inventory.panel3 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel3.png')
    inventory.panel4 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel4.png')
    inventory.panel5 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel5.png')
    inventory.panel6 = love.graphics.newImage('sprites/UI/Inventory/InventoryPanel6.png')

    inventory.sword = love.graphics.newImage('sprites/UI/sword.png')
    inventory.healing = love.graphics.newImage('sprites/UI/healing.png')
end

function inventory.update(dt)
    healingAmount = love.graphics.newText(gameFont, tostring(saveData.healing))
end

function inventory.draw()
    if player.itemState == 1 then
        love.graphics.draw(inventory.panel1, 285, 1000, nil, 4.5, 4.5, 64, 16)
    elseif player.itemState == 2 then
        love.graphics.draw(inventory.panel2, 285, 1000, nil, 4.5, 4.5, 64, 16)
    elseif player.itemState == 3 then
        love.graphics.draw(inventory.panel3, 285, 1000, nil, 4.5, 4.5, 64, 16)
    elseif player.itemState == 4 then
        love.graphics.draw(inventory.panel4, 285, 1000, nil, 4.5, 4.5, 64, 16)
    elseif player.itemState == 5 then
        love.graphics.draw(inventory.panel5, 285, 1000, nil, 4.5, 4.5, 64, 16)
    elseif player.itemState == 6 then
        love.graphics.draw(inventory.panel6, 285, 1000, nil, 4.5, 4.5, 64, 16)
    end

    -- Sword
    love.graphics.draw(inventory.sword, 105, 1000, nil, 1.6, 1.6, 16, 16)

    -- Healing potion
    love.graphics.draw(inventory.healing, 466, 1000, nil, 1.6, 1.6, 16, 16)
    love.graphics.draw(healingAmount, 487, 1005, nil, 1.5, 1.5)
end