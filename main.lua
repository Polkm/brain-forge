function requiredir(dir)
  for _, file in pairs(love.filesystem.getDirectoryItems(dir)) do
    require(dir .. "/" .. string.gsub(file, ".lua", ""))
  end
end
requiredir("modules")
requiredir("simulation")

local sim = simulation({})
controls.simulation = sim

function love.load()
  sim.init()
  sim.reset()
end

function love.update(dt)
  sim.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(50, 50, 50, 255)

  sim.draw()

  -- Top left info

  local console = ""

  local fps = "fps:" .. love.timer.getFPS()
  local dt = "dt:" .. math.floor(love.timer.getAverageDelta() * 1000) .. "ms"
  local stats = love.graphics.getStats()
  local statStr = ""
  for stat, v in pairs(stats) do
    if stat == "texturememory" then
      statStr = statStr .. "\n" .. stat .. ": " .. math.floor(v / 1024 / 1024 * 10) / 10 .. "mbs"
    else
      statStr = statStr .. "\n" .. stat .. ": " .. v .. ""
    end
  end
  love.graphics.printf(fps .. " " .. dt .. "  " .. statStr .. "\n" .. console, 0, 0, love.graphics.getWidth())
end
