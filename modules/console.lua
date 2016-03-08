local p = {}

p.stats = {}
p.console = ""

local oldPrint = print
function print(...)
  for i, v in ipairs({...}) do
    if i == 1 then
      p.console = p.console .. tostring(v)
    else
      p.console = p.console .. "\t" .. tostring(v)
    end
  end
  p.console = p.console .. "\n"
  oldPrint(...)
end

function p.draw()
  local fps = "fps:" .. love.timer.getFPS()
  local dt = "dt:" .. math.floor(love.timer.getAverageDelta() * 1000) .. "ms"
  local stats = love.graphics.getStats()
  stats.texturememory = math.floor(stats.texturememory / 1024 / 1024 * 10) / 10 .. "mbs"
  local statStr = ""
  for stat, v in pairs(stats) do
    statStr = statStr .. "\n" .. stat .. ": " .. v .. ""
  end
  for stat, v in pairs(p.stats) do
    if type(v) == "table" then
      statStr = statStr .. "\n" .. stat .. ": " .. table.concat(v, "\t") .. ""
    else
      statStr = statStr .. "\n" .. stat .. ": " .. v .. ""
    end
  end
  love.graphics.setShader()
  love.graphics.setColor(255, 255, 255, 150)
  love.graphics.setFont(cache.get.font("fonts/Rubik-Regular.ttf", 14))
  love.graphics.printf(fps .. " " .. dt .. "  " .. statStr .. "\n" .. p.console, 0, 0, love.graphics.getWidth())
end

console = p
