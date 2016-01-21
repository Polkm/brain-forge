function simulation(p)

  p.layers = {}
  p.layerBuffers = {}
  p.size = 1000

  p.initShader = love.graphics.newShader("shaders/brain-init.frag")
  p.updateShader = love.graphics.newShader("shaders/brain-update.frag")

  p.volumeRotation = math.pi * 0.25
  p.volumeTilt = math.pi * 0.25
  p.volumeZoom = 2
  p.frameTime = 0
  p.frame = 0
  p.paused = false

  p.panX, p.panY = 0, 0

  local function safeSend(name, value)
    local shader = love.graphics.getShader()
    if shader:getExternVariable(name) then
      shader:send(name, value)
    end
  end

  function p.init()
    for i = 1, p.size do
      p.layers[i] = love.graphics.newCanvas(p.size, p.size)
      p.layers[i]:setFilter("nearest", "nearest")
      p.layerBuffers[i] = love.graphics.newCanvas(p.size, p.size)
      p.layerBuffers[i]:setFilter("nearest", "nearest")
    end
  end

  function p.initCells()
    love.graphics.setShader(p.initShader)
    safeSend("resolusion", {p.size, p.size})
    safeSend("seed", math.random())
    for z = 1, p.size do
      safeSend("layerz", z)
      love.graphics.setCanvas(p.layerBuffers[z])
      love.graphics.draw(p.layers[z])
      p.layers[z], p.layerBuffers[z] = p.layerBuffers[z], p.layers[z]
    end
    love.graphics.setCanvas()
  end

  function p.reset()
    -- Clear the cell layers
    love.graphics.setBackgroundColor(0, 0, 0, 0)
    for i = 1, p.size do
      love.graphics.setCanvas(p.layers[i])
      love.graphics.clear()
      love.graphics.setCanvas(p.layerBuffers[i])
      love.graphics.clear()
    end
    love.graphics.setBackgroundColor(50, 50, 50, 255)
    love.graphics.setCanvas()

    -- Init a new batch of brain cells
    p.initCells()
  end

  function p.update(dt)

  end

  local zprogress = 1

  function p.draw()

    if not p.paused then
      local startTime = love.timer.getTime()

      love.graphics.setShader(p.updateShader)

      while love.timer.getTime() - startTime < 1 / 1000 do
        love.graphics.setCanvas(p.layerBuffers[zprogress])
        if p.layers[zprogress + 1] then
          safeSend("above", p.layers[zprogress + 1])
        end
        if p.layers[zprogress - 1] then
          safeSend("bellow", p.layers[zprogress - 1])
        end
        safeSend("resolusion", {p.size, p.size})
        safeSend("layerz", zprogress)
        safeSend("frame", p.frame)
        love.graphics.draw(p.layers[zprogress])

        zprogress = zprogress + 1

        if zprogress > p.size then
          zprogress = 1
          p.frame = p.frame + 1

          for z = 1, p.size do
            p.layers[z], p.layerBuffers[z] = p.layerBuffers[z], p.layers[z]
            love.graphics.setCanvas(p.layerBuffers[z])
            love.graphics.clear()
          end

          break
        end
      end
    end

    love.graphics.setShader()
    love.graphics.setCanvas()

    for z = 1, p.size do
      love.graphics.setColor(255, 255, 255, 5 + 20 * math.sin(p.volumeTilt))
      -- love.graphics.setColor(255, 255, 255, 255)
      love.graphics.push()
      love.graphics.translate(love.graphics.getWidth() * 0.5 + p.panX, love.graphics.getHeight() * 0.5 + p.panY)

      love.graphics.translate(0, -(z - p.size * 0.5) * math.sin(p.volumeTilt) * p.volumeZoom)
      love.graphics.scale(p.volumeZoom, p.volumeZoom * math.cos(p.volumeTilt))

      love.graphics.rotate(p.volumeRotation)
      love.graphics.translate(-p.size * 0.5, -p.size * 0.5)

      assert(p.layers[z], z)
      love.graphics.draw(p.layers[z])

      love.graphics.setColor(255, 255, 255, 50)
      love.graphics.setPointSize(1 * p.volumeZoom)
      love.graphics.points(0, 0)
      love.graphics.points(p.size, 0)
      love.graphics.points(0, p.size)
      love.graphics.points(p.size, p.size)
      if z == 1 or z == p.size then
        love.graphics.rectangle("line", 0, 0, p.size, p.size)
      end

      love.graphics.pop()
    end
  end



  return p
end
