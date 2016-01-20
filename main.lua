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
local size = 200
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
  love.graphics.setCanvas(layers[z])
  love.graphics.setColor(r, g, b, a)
  love.graphics.points(x, y)
  love.graphics.setCanvas()
end

function love.load()

  setPixel(size / 2,  size / 2, size / 2, 255, 255, 0, 255)
  -- setPixel(0, 0, size, 255, 0, 0, 255)

end

function love.update(dt)
end

local function safeSend(name, value)
  local shader = love.graphics.getShader()
  if shader:getExternVariable(name) then
    shader:send(name, value)
  end
end

function love.draw()

  love.graphics.setBackgroundColor(50, 50, 50, 255)

  love.graphics.setShader(cellShader)

  for z = 1, size do
    love.graphics.setCanvas(layerBuffers[z])
    if layers[z + 1] then
      safeSend("above", layers[z + 1])
    end
    if layers[z - 1] then
      safeSend("bellow", layers[z - 1])
    end
    safeSend("resolusion", {size, size})
    safeSend("layerz", z)
    love.graphics.draw(layers[z])
  end

  for z = 1, size do
    layers[z], layerBuffers[z] = layerBuffers[z], layers[z]
  end

  love.graphics.setShader()
  love.graphics.setCanvas()

  for z = 1, size do
    love.graphics.setColor(255, 255, 255, 255 / size)
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
    love.graphics.scale(2, 1.5)
    love.graphics.translate(0, -z - size * 0.25)
    love.graphics.rotate(math.pi * 0.25)

    love.graphics.draw(layers[z])

    love.graphics.pop()
  end

end
