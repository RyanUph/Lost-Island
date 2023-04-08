sti = require('libraries/sti')

function loadMap(mapName)
    gameMap = sti('maps/' .. mapName .. '.lua')

    fencesRC = {}
    tressRC = {}

    if gameMap.layers["TreesRC"] then
        for i, obj in ipairs(gameMap.layers["TreesRC"].objects) do
            tree = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 60)
            tree:setType('static')
            table.insert(tressRC, tree)
        end
    end

    if gameMap.layers["FencesRC"] then
        for i, obj in ipairs(gameMap.layers["FencesRC"].objects) do
            fence = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 10)
            fence:setType('static')
            table.insert(fencesRC, fence)
        end
    end
end