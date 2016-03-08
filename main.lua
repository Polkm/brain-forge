function requiredir(dir)
  for _, file in pairs(love.filesystem.getDirectoryItems(dir)) do
    require(dir .. "/" .. string.gsub(file, ".lua", ""))
  end
end
requiredir("modules")

requiredir("simulation")
requiredir("gui")
requiredir("menus")


local sim

function love.load()

end

function love.filedropped(file)
  local filename = file:getFilename()
  local size = tonumber(string.match(filename, "_(%d+).csv"))
  if string.find(filename, "InitState") then
    local initState = {}

    local n = -1
    for line in file:lines() do
      if n >= 0 then
        local typ = tonumber(string.char(string.byte(line, string.len(line) - 1)))
        initState[n] = typ
      end
      n = n + 1
    end

    -- file, err = love.filesystem.newFile(, "r")
    -- assert(false, err)
    file = io.open(string.gsub(filename, "InitState", "ChangeState"), "r")
    local stateChanges = {}
    local changes = -1
    local maxFrames = 0
    for line in file:lines() do
      -- print(line)
      if line and changes >= 0 then
        local x, y, z, typ, tim = string.match(line, "(%d+),(%d+),(%d+),(%d+),(%d+)")

        x, y, z, typ, tim = tonumber(y), tonumber(z), tonumber(x), tonumber(typ), tonumber(tim)

        stateChanges[tim] = stateChanges[tim] or {}
        stateChanges[tim][z] = stateChanges[tim][z] or {}
        stateChanges[tim][z][#stateChanges[tim][z] + 1] = {x = x, y = y, typ = typ}
        maxFrames = math.max(maxFrames, tim)
      end
      changes = changes + 1
    end
    if sim then
      sim.stateChanges = stateChanges
    end

    display.playBack = 0
    display.maxFrames = maxFrames

    sim = simulation({size = size, initState = initState, stateChanges = stateChanges})
    sim.init()
    sim.reset()
  end
  if string.find(filename, "ChangeState") then


    -- _G.menu.refresh()

  end
end

function love.update(dt)
  if sim then
    sim.update(dt)
  end

  gui.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(50, 50, 50, 255)

  if sim then
    sim.draw()
  end

  gui.draw()

  console.draw()
end
