menu = {}

function menu.load()
    text1 = love.graphics.newText(gameFont, "Press 'SPACE' to start")
    text2 = love.graphics.newText(gameFont, "Press 'ESCAPE' to exit")
    text3 = love.graphics.newText(gameFont, "Press 'WASD' to move")
    text4 = love.graphics.newText(gameFont, "Press 'Mouse1' to attack")
end

function menu.draw()
    love.graphics.draw(text1, 460, 100, nil, 5, 5)
    love.graphics.draw(text2, 460, 200, nil, 5, 5)
    love.graphics.draw(text3, 460, 400, nil, 5, 5)
    love.graphics.draw(text4, 460, 500, nil, 5, 5)
end