cache = {}

local localCache = {}

local misses = 0

function cache.purge(key)
  localCache = {}
end

cache.get = setmetatable({}, {
  __index = function(t, key)
    t[key] = function(...)
      local args = {...}
      if #args < 1 then return end
      if not localCache[key] then localCache[key] = {} end

      local tbl = localCache[key]
      for n, v in ipairs(args) do
        if not tbl[v] then
          if n == #args and cache[key] then
            tbl[v] = cache[key](...)
            -- println("miss " .. key .. " " .. misses)
            misses = misses + 1
          else
            tbl[v] = {}
          end
        end
        tbl = tbl[v]
      end

      return tbl
    end
    return t[key]
  end
})

cache.set = setmetatable({}, {
  __index = function(t, key)
    t[key] = function(...)
      local args = {...}
      if #args < 1 then return end
      if not localCache[key] then localCache[key] = {} end

      local tbl = localCache[key]
      for n, v in ipairs(args) do
        if not tbl[v] then
          if n == #args then
            tbl[v] = v
            -- println("miss " .. key .. " " .. misses)
            misses = misses + 1
          else
            tbl[v] = {}
          end
        end
        tbl = tbl[v]
      end

      return tbl
    end
    return t[key]
  end
})

function cache.code(filename)
  return require(filename)
end

function cache.data(file)
  if type(file) == "string" then
    file = cache.get.code("data/" .. file)
  end
  return file.map(function(class, func)
    local obj = new[class]()
    obj.set.class(class)
    return obj
  end)
end

local function newImage(arg)
  local img = love.graphics.newImage(arg)
  img:setFilter("nearest", "nearest")
  return img
end

function cache.image(filename)
  return newImage(filename)
end

function cache.crop(image, x, y, w, h)
  local data = love.image.newImageData(w, h)
  data:paste(image:getData(), 0, 0, x, y, w, h)
  return newImage(data)
end

function cache.imageData(w, h)
  return love.image.newImageData(w, h)
end

function cache.atlas(image, index, w, h)
  w, h = w or 16, h or 16
  local atlasData = image:getData()
  local imageData = love.image.newImageData(w, h)
  local xFrames = math.floor(atlasData:getWidth() / w)
  local frames = xFrames * math.floor(atlasData:getHeight() / h)
  index = math.min(math.max(index, 0), frames - 1)
  local x = (index % xFrames) * w
  local y = math.floor(index / xFrames) * h
  imageData:paste(atlasData, 0, 0, x, y, w, h)
  return newImage(imageData)
end

function cache.frame(filename, frame)
  local img = cache.image(filename)
  return cache.atlas(img, frame, img:getHeight(), img:getHeight())
end

function cache.font(filename, size)
  local font = love.graphics.newFont(filename, size)
  font:setFilter("nearest", "nearest", 0)
  font:setLineHeight(0.65)
  return font
end

function cache.whiteImage(colorImage)
  local data = love.image.newImageData(colorImage:getData():getWidth(), colorImage:getData():getHeight())
  colorImage:getData():mapPixel(function(x, y, r, g, b, a)
    if a > 0 then
      data:setPixel(x, y, 255, 255, 255, a)
    end
    return r, g, b, a
  end)
  local img = newImage(data)
  img:refresh()
  return img
end

function cache.shader(filename)
  local success, result = pcall(love.graphics.newShader, filename)
  assert(success, "Error compiling shader!\n" .. tostring(result))
  return result
end

function cache.audio(filename, type)
  return love.audio.newSource(filename, type)
end

function cache.cursor(filename, hotspot)
  return love.mouse.newCursor(filename, hotspot.x, hotspot.y)
end

function cache.imageBounds(image)
  local min, max = love.image.minmax(image)
  return {min = min, max = max}
end

function cache.canvas(width, height, name)
  return love.graphics.newCanvas(width, height)
end
