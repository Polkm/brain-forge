function requiredir(dir)
  for _, file in pairs(love.filesystem.getDirectoryItems(dir)) do
    require(dir .. "/" .. string.gsub(file, ".lua", ""))
  end
end

-- requiredir("modules")
-- requiredir("structs")
-- requiredir("scenes")
-- requiredir("life")

local layers = {}
local layerBuffers = {}
local size = 100
for i = 1, size do
  layers[i] = love.graphics.newCanvas(size, size)
  layers[i]:setFilter("nearest", "nearest")
end
for i = 1, size do
  layerBuffers[i] = love.graphics.newCanvas(size, size)
  layerBuffers[i]:setFilter("nearest", "nearest")
end

local cellShader = love.graphics.newShader("brain-shader.frag")
-- local canvas = love.graphics.newCanvas(size, size)

local function setPixel(x, y, z, r, g, b, a)
  love.graphics.setCanvas(layers[math.floor(z)])
  love.graphics.setColor(r, g, b, a)
  love.graphics.points(math.floor(x), math.floor(y))
  love.graphics.setCanvas()
end

local function randomPixel()
  setPixel(math.random(0, size - 1), math.random(0, size - 1), math.random(1, size), 255, 255, 255)
end

function love.load()
  for i = 1, (size * size * size) / 10 do
    randomPixel()
  end
end



local function safeSend(name, value)
  local shader = love.graphics.getShader()
  if shader:getExternVariable(name) then
    shader:send(name, value)
  end
end

local volumeRotation = math.pi * 0.25
local volumeTilt = math.pi * 0.25
local volumeZoom = 6

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    volumeRotation = volumeRotation - dx / 100
    volumeTilt = math.min(math.max(volumeTilt - dy / 500, 0.02), math.pi * 0.48)
  end
end

function love.draw()

  love.graphics.setBackgroundColor(50, 50, 50, 255)

  love.graphics.setShader(cellShader)

  for z = 1, size do
    love.graphics.setCanvas(layerBuffers[z])
    -- love.graphics.clear()

    -- if layers[z + 1] then
    --   safeSend("above", layers[z + 1])
    -- end
    -- if layers[z - 1] then
    --   safeSend("bellow", layers[z - 1])
    -- end
    safeSend("resolusion", {size, size})
    safeSend("layerz", z)
    love.graphics.draw(layers[z])
  end

  for z = 1, size do
    layers[z], layerBuffers[z] = layerBuffers[z], layers[z]
    love.graphics.setCanvas(layerBuffers[z])
    love.graphics.clear()
  end

  love.graphics.setShader()
  love.graphics.setCanvas()

  for z = 1, size do
    love.graphics.setColor(255, 255, 255, 10 + 50 * math.sin(volumeTilt))
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

    love.graphics.translate(0, -(z - size * 0.5) * math.sin(volumeTilt) * volumeZoom)
    love.graphics.scale(volumeZoom, volumeZoom * math.cos(volumeTilt))

    love.graphics.rotate(volumeRotation)
    love.graphics.translate(-size * 0.5, -size * 0.5)

    love.graphics.draw(layers[z])

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.points(0, 0)
    love.graphics.points(size, 0)
    love.graphics.points(0, size)
    love.graphics.points(size, size)

    love.graphics.pop()
  end

end
