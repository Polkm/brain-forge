function simulation(p)
  p.layers = {}
  p.layerBuffers = {}
  p.size = p.size or 100

  p.initShader = love.graphics.newShader("shaders/brain-init.frag")
  p.updateShader = love.graphics.newShader("shaders/brain-update.frag")
  p.renderShader = love.graphics.newShader("shaders/brain-render.frag")

  p.volumeRotation = math.pi * 0.25
  p.volumeTilt = math.pi * 0.25
  p.volumeZoom = 2
  p.frame = 0
  p.lastFrame = love.timer.getTime()
  p.paused = false
  p.zprogress = 1

  p.initState = p.initState or nil
  p.stateChanges = p.stateChanges or nil

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

  local function drawCell(x, y, typ)
    if typ == 0 then
      love.graphics.setColor(0, 0, 0, 1)
    elseif typ == 1 then
      love.graphics.setColor(0, 0, 0, 0)
    elseif typ == 2 then
      love.graphics.setColor(0, 0, 0, 2)
    elseif typ == 3 then
      love.graphics.setColor(0, 0, 0, 0)
    else
      -- assert(false, typ)
      love.graphics.setColor(0, 0, 0, 0)
    end
    love.graphics.points(x, y)
  end

  function p.initCells()
    if p.initState then
      for z = 1, p.size do
        love.graphics.setCanvas(p.layerBuffers[z])

        for x = 0, p.size - 1 do
          for y = 0, p.size - 1 do
            local i = x + y * p.size + (z - 1) * p.size * p.size
            local typ = p.initState[i]
            drawCell(x, y, typ)
          end
        end

        p.layers[z], p.layerBuffers[z] = p.layerBuffers[z], p.layers[z]
      end
      love.graphics.setCanvas()
    else
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
  end

  function p.swapBuffers()
    p.zprogress = 1

    -- love.graphics.setBackgroundColor(0, 0, 0, 0)
    -- for z = 1, p.size do
    --   p.layers[z], p.layerBuffers[z] = p.layerBuffers[z], p.layers[z]
    --   love.graphics.setCanvas(p.layerBuffers[z])
    --   love.graphics.clear()
    -- end
    -- love.graphics.setBackgroundColor(50, 50, 50, 255)
  end

  function p.reset()
    p.frame = 0

    p.swapBuffers()

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

  function p.draw()

    if not p.paused then
      if p.stateChanges then

        if p.frame < display.playBack and p.stateChanges[p.frame] then
          local layerChanges = p.stateChanges[p.frame]

          for z, changes in pairs(layerChanges) do
            local lz = z + 1
            love.graphics.setCanvas(p.layerBuffers[lz])
            love.graphics.clear(0, 0, 0, 0)

            for i, change in pairs(changes) do
              drawCell(change.x, change.y, change.typ)
            end

            p.layers[lz], p.layerBuffers[lz] = p.layerBuffers[lz], p.layers[lz]
          end

          love.graphics.setCanvas()

          p.frame = p.frame + 1
        end
      else
        local startTime = love.timer.getTime()

        love.graphics.setShader(p.updateShader)
        safeSend("resolusion", {p.size, p.size})
        safeSend("frame", p.frame)

        love.graphics.setBlendMode("alpha", "premultiplied")

        while love.timer.getTime() - startTime < 1 / 1000 do
          love.graphics.setCanvas(p.layerBuffers[p.zprogress])
          safeSend("layerz", p.zprogress)
          if p.layers[p.zprogress + 1] then
            safeSend("above", p.layers[p.zprogress + 1])
          end
          if p.layers[p.zprogress - 1] then
            safeSend("bellow", p.layers[p.zprogress - 1])
          end

          love.graphics.draw(p.layers[p.zprogress])

          p.zprogress = p.zprogress + 1

          if p.zprogress > p.size then

            p.frame = p.frame + 1

            p.swapBuffers()

            break
          end
        end
      end
    end

    love.graphics.setShader(p.renderShader)
    safeSend("resolusion", {p.size, p.size})
    safeSend("frame", p.frame)

    love.graphics.setCanvas()

    love.graphics.setBlendMode("alpha")

    local grid1 = p.size / 2

    for z = 1, p.size do
      safeSend("layerz", z)

      local layerAlpha = 255 * display.layerAlpha + 10 * math.sin(p.volumeTilt)

      love.graphics.setColor(255, 255, 255, layerAlpha)
      -- love.graphics.setColor(255, 255, 255, 255)
      love.graphics.push()
      love.graphics.translate(love.graphics.getWidth() * 0.5 + p.panX, love.graphics.getHeight() * 0.5 + p.panY)

      local spread = 1 + display.layerSpread * 5.0

      love.graphics.translate(0, -(z - p.size * 0.5) * spread * math.sin(p.volumeTilt) * p.volumeZoom)
      love.graphics.scale(p.volumeZoom, p.volumeZoom * math.cos(p.volumeTilt))

      love.graphics.rotate(p.volumeRotation)
      love.graphics.translate(-p.size * 0.5, -p.size * 0.5)

      assert(p.layers[z], z)
      love.graphics.draw(p.layers[z])


      love.graphics.setShader()
      love.graphics.setLineWidth(0.2)
      love.graphics.setColor(255, 255, 255, layerAlpha * 0.8)
      -- love.graphics.setPointSize(1 * p.volumeZoom)
      -- love.graphics.points(0, 0)
      -- love.graphics.points(p.size, 0)
      -- love.graphics.points(0, p.size)
      -- love.graphics.points(p.size, p.size)
      if z == 1 or z == p.size then
        love.graphics.rectangle("line", 0, 0, p.size, p.size)
      end

      love.graphics.setColor(255, 255, 255, layerAlpha * 0.5)
      if math.floor(z % grid1) == 0 then
        -- love.graphics.rectangle("line", 0, 0, p.size, p.size)
        for x = 0, (p.size / grid1) do
          love.graphics.line(x * grid1, 0, x * grid1, p.size)
          love.graphics.line(0, x * grid1, p.size, x * grid1)
        end
        -- love.graphics.line(0, 0, p.size, 0)
        -- love.graphics.line(0, 0, 0, p.size)
        -- love.graphics.line(p.size, p.size, p.size, 0)
        -- love.graphics.line(p.size, p.size, 0, p.size)
      end


      love.graphics.setShader(p.renderShader)

      love.graphics.pop()
    end

    love.graphics.setShader()
  end

  controls.simulation = p

  return p
end
