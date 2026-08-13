-- COLOR CHAOS PUZZLE (WITH ANIMATIONS)
-- Single-file LOVE2D game

NORMAL, BOMB, FREEZE, LOCK = 0, 1, 2, 3

colors = {
    {1, 0.4, 0.4},
    {0.4, 1, 0.4},
    {0.4, 0.4, 1}
}

windowWidth, windowHeight = 700, 900
topUI, margin = 130, 20

level = 1
gridSize = 3
grid = {}
tileType = {}
lockTimer = {}

-- animation state
animScale = {}
animTimer = {}

score = 0
gameWon = false

autoTimer = 0
autoInterval = 2
minInterval = 0.35
freezeTimer = 0

tileSize, offsetX, offsetY = 80, 0, 0

-- =====================
function love.load()
    love.window.setTitle("Color Chaos Puzzle")
    love.window.setMode(windowWidth, windowHeight)
    math.randomseed(os.time())
    startLevel()
end

-- =====================
function computeLayout()
    tileSize = math.min(
        (windowWidth - margin * 2) / gridSize,
        (windowHeight - topUI - margin * 2) / gridSize
    )
    offsetX = (windowWidth - tileSize * gridSize) / 2
    offsetY = topUI + (windowHeight - topUI - tileSize * gridSize) / 2
end

-- =====================
function startLevel()
    gameWon = false
    autoTimer = 0
    freezeTimer = 0

    gridSize = 2 + level
    autoInterval = math.max(2 - level * 0.2, minInterval)

    computeLayout()

    grid, tileType, lockTimer = {}, {}, {}
    animScale, animTimer = {}, {}

    local baseColor = math.random(#colors)

    for i = 1, gridSize do
        grid[i], tileType[i], lockTimer[i] = {}, {}, {}
        animScale[i], animTimer[i] = {}, {}
        for j = 1, gridSize do
            grid[i][j] = baseColor
            tileType[i][j] = getRandomTileType()
            lockTimer[i][j] = tileType[i][j] == LOCK and 5 or 0
            animScale[i][j] = 1
            animTimer[i][j] = 0
        end
    end

    for k = 1, level * 2 do randomChaos() end
end

function getRandomTileType()
    local r = math.random(100)
    if level >= 2 and r <= 10 then return BOMB end
    if level >= 3 and r <= 18 then return FREEZE end
    if level >= 4 and r <= 25 then return LOCK end
    return NORMAL
end

-- =====================
function love.update(dt)
    if gameWon then return end

    -- tile animations
    for i = 1, gridSize do
        for j = 1, gridSize do
            if animTimer[i][j] > 0 then
                animTimer[i][j] = animTimer[i][j] - dt
                animScale[i][j] = 1 + 0.15 * math.sin(animTimer[i][j] * 20)
            else
                animScale[i][j] = 1
            end

            if tileType[i][j] == LOCK then
                lockTimer[i][j] = lockTimer[i][j] - dt
                if lockTimer[i][j] <= 0 then
                    tileType[i][j] = NORMAL
                end
            end
        end
    end

    if freezeTimer > 0 then
        freezeTimer = freezeTimer - dt
        return
    end

    if similarityRatio() > 0.8 then return end

    autoTimer = autoTimer + dt
    if autoTimer >= autoInterval then
        autoTimer = 0
        randomChaos()
    end
end

-- =====================
function love.draw()
    love.graphics.clear(0.12, 0.12, 0.18)

    -- UI
    love.graphics.setColor(1,1,1)
    love.graphics.print("Level: " .. level, 30, 30)
    love.graphics.print("Score: " .. score, 30, 60)
    love.graphics.print("Freeze: " .. math.ceil(freezeTimer), 30, 90)

    for i = 1, gridSize do
        for j = 1, gridSize do
            local x = offsetX + (i - 1) * tileSize
            local y = offsetY + (j - 1) * tileSize
            local s = animScale[i][j]

            love.graphics.push()
            love.graphics.translate(x + tileSize/2, y + tileSize/2)
            love.graphics.scale(s, s)
            love.graphics.translate(-tileSize/2, -tileSize/2)

            love.graphics.setColor(colors[grid[i][j]])
            love.graphics.rectangle(
                "fill", 0, 0,
                tileSize - 6,
                tileSize - 6,
                tileSize * 0.2,
                tileSize * 0.2
            )

            love.graphics.setColor(1,1,1)
            if tileType[i][j] == BOMB then
                love.graphics.print("💣", tileSize*0.35, tileSize*0.35)
            elseif tileType[i][j] == FREEZE then
                love.graphics.print("❄", tileSize*0.35, tileSize*0.35)
            elseif tileType[i][j] == LOCK then
                love.graphics.print("🔒", tileSize*0.33, tileSize*0.35)
            end

            love.graphics.pop()
        end
    end

    if gameWon then
        love.graphics.print("🎉 LEVEL CLEARED!", windowWidth/2 - 80, topUI - 50)
        love.graphics.print("Click to continue", windowWidth/2 - 70, topUI - 25)
    end
end

-- =====================
function love.mousepressed(x, y)
    if gameWon then
        level = level + 1
        startLevel()
        return
    end

    for i = 1, gridSize do
        for j = 1, gridSize do
            local tx = offsetX + (i - 1) * tileSize
            local ty = offsetY + (j - 1) * tileSize
            if x > tx and x < tx + tileSize and y > ty and y < ty + tileSize then
                handleTileClick(i, j)
            end
        end
    end
end

function handleTileClick(i, j)
    if tileType[i][j] == LOCK then return end

    score = score + 1
    animTimer[i][j] = 0.25

    if tileType[i][j] == BOMB then
        explode(i, j)
    elseif tileType[i][j] == FREEZE then
        freezeTimer = 3
    else
        grid[i][j] = grid[i][j] % #colors + 1
    end

    if checkWin() then gameWon = true end
end

-- =====================
function randomChaos()
    local i, j = math.random(gridSize), math.random(gridSize)
    grid[i][j] = math.random(#colors)
    animTimer[i][j] = 0.25
end

function explode(i, j)
    local c = grid[i][j]
    for dx = -1,1 do
        for dy = -1,1 do
            local x, y = i+dx, j+dy
            if grid[x] and grid[x][y] then
                grid[x][y] = c
                animTimer[x][y] = 0.3
            end
        end
    end
end

function checkWin()
    local f = grid[1][1]
    for i=1,gridSize do
        for j=1,gridSize do
            if grid[i][j] ~= f then return false end
        end
    end
    return true
end

function similarityRatio()
    local t, same = grid[1][1], 0
    for i=1,gridSize do
        for j=1,gridSize do
            if grid[i][j] == t then same = same + 1 end
        end
    end
    return same / (gridSize * gridSize)
end
