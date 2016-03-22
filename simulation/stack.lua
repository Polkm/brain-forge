function stack(p)

  local layers = {}

  function p.update(dt)

  end

  function p.getWeightColor(x, y, weight)
    local r, g, b, a = 0, 0, 0, 255

    if weight > 0 then
      r, g, b = math.lerp3(r, g, b, 19, 135, 164, math.clamp(weight * 10, 0, 1))
    else
      r, g, b = math.lerp3(r, g, b, 208, 22, 57, math.clamp(-weight * 10, 0, 1))
    end


    return r, g, b, a
    -- return math.clamp(-weight * 100, 0, 255), 0, math.clamp(weight * 100, 0, 255), a
  end

  function p.getLayer(k, module)
    if not layers[k] then
      layers[k] = {}
    end
    if layers[k].module ~= module or not layers[k].image then
      layers[k].module = module
      local img, data

      local weight = module.weight
      if not weight and module.output then print(module.output) weight = module.output end
      if weight then
        local dim = weight:dim()


        if dim == 4 then
          local ww = weight:size(1)
          local hh = weight:size(2)
          local w = weight:size(3)
          local h = weight:size(4)

          data = love.image.newImageData(ww * w, hh * h)

          for xx = 1, ww do
            for yy = 1, hh do
              for x = 1, w do
                for y = 1, h do
                  local xxx, yyy = (xx - 1) * (w) + (x - 1), (yy - 1) * (h) + (y - 1)
                  local r, g, b, a = p.getWeightColor(xxx, yyy, weight[xx][yy][x][y])
                  if ((xx + (yy % 2 == 0 and 1 or 0)) % 2 == 0) then
                    -- r, g, b = color.mult(0.5, r, g, b)
                  end
                  data:setPixel(xxx, yyy, r, g, b, a)
                end
              end
            end
          end

        elseif dim == 2 then
          local w = weight:size(1)
          local h = weight:size(2)

          data = love.image.newImageData(w, h)

          for x = 1, w do
            for y = 1, h do
              local xxx, yyy = (x - 1), (y - 1)
              data:setPixel(xxx, yyy, p.getWeightColor(xxx, yyy, weight[x][y]))
            end
          end

        else
          data = love.image.newImageData(2, 2)

          data:mapPixel(function(x, y, r, g, b, a)
            return x, y, ((x + (y % 2 == 0 and 1 or 0)) % 2 == 0) and 50 or 0, 255
          end)

        end
      else

        data = love.image.newImageData(2, 2)

        data:mapPixel(function(x, y, r, g, b, a)
          return x, y, ((x + (y % 2 == 0 and 1 or 0)) % 2 == 0) and 50 or 0, 255
        end)
      end



      local img = love.graphics.newImage(data)
      img:setFilter("nearest", "nearest")
      layers[k].image = img
    end
    return layers[k].image
  end

  function p.draw()
    if p.net then
      local sw, sh = love.graphics.getDimensions()

      love.graphics.push()
      love.graphics.translate(sw * 0.5 + display.panX, sh * 0.5 + display.panY)
      -- love.graphics.scale(display.zoom, display.zoom)

      local z = 0

      for k, module in pairs(p.net.modules) do
        local img = p.getLayer(k, module)
        local w, h = img:getDimensions()

        love.graphics.push()
        local spread = 1 + display.layerSpread * 30.0
        love.graphics.translate(0, -(k * 10) * spread * math.sin(display.tilt) * display.zoom)
        love.graphics.scale(display.zoom, display.zoom * math.cos(display.tilt))

        love.graphics.rotate(display.rotation)
        love.graphics.translate(-w * 0.5, -h * 0.5)

        -- for d = 1, module.weight:dim() do
        --   for
        -- print(module.weight)
        -- print(module.weight:size(1))
        -- print(p.getLayer(k, module))

        love.graphics.setColor(255, 255, 255, (1 - display.layerAlpha) * 255)
        love.graphics.draw(img, 0, 0)

        -- z = z - h - 2
        -- love.graphics.draw(img, w * 0.5, h)


        love.graphics.pop()
      end

      love.graphics.pop()
      -- p.net = false
    end
  end

  return p
end
