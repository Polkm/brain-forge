function requiredir(dir)
  for _, file in pairs(love.filesystem.getDirectoryItems(dir)) do
    require(dir .. "/" .. string.gsub(file, ".lua", ""))
  end
end
requiredir("modules")

requiredir("simulation")
requiredir("gui")
requiredir("menus")

-- require("torch")
-- require("cutorch")

require("nn")


sim = nil

testStack = stack({})

function love.load()
  net = nn.Sequential()
  net:add(nn.SpatialConvolution(1, 6, 5, 5)) -- 1 input image channel, 6 output channels, 5x5 convolution kernel
  net:add(nn.ReLU())                       -- non-linearity
  net:add(nn.SpatialMaxPooling(2,2,2,2))     -- A max-pooling operation that looks at 2x2 windows and finds the max.
  net:add(nn.SpatialConvolution(6, 16, 5, 5))
  net:add(nn.ReLU())                       -- non-linearity
  net:add(nn.SpatialMaxPooling(2,2,2,2))
  net:add(nn.View(16*5*5))                    -- reshapes from a 3D tensor of 16x5x5 into 1D tensor of 16*5*5
  net:add(nn.Linear(16*5*5, 120))             -- fully connected layer (matrix multiplication between input and weights)
  net:add(nn.ReLU())                       -- non-linearity
  net:add(nn.Linear(120, 84))
  net:add(nn.ReLU())                       -- non-linearity
  net:add(nn.Linear(84, 10))                   -- 10 is the number of outputs of the network (in this case, 10 digits)
  net:add(nn.LogSoftMax())                     -- converts the output to a log-probability. Useful for classification problems

  testStack.net = net



  -- print('Lenet5\n' .. net:__tostring());
end

function love.filedropped(file)
  -- local filename = file:getFilename()
  -- local size = tonumber(string.match(filename, "_(%d+).csv"))
  -- if string.find(filename, "InitState") then
  --   local initState = {}
  --
  --   local n = -1
  --   for line in file:lines() do
  --     if n >= 0 then
  --       local typ = tonumber(string.char(string.byte(line, string.len(line) - 1)))
  --       initState[n] = typ
  --     end
  --     n = n + 1
  --   end
  --
  --   -- file, err = love.filesystem.newFile(, "r")
  --   -- assert(false, err)
  --   file = io.open(string.gsub(filename, "InitState", "ChangeState"), "r")
  --   local stateChanges = {}
  --   local changes = -1
  --   local maxFrames = 0
  --   for line in file:lines() do
  --     -- print(line)
  --     if line and changes >= 0 then
  --       local x, y, z, typ, tim = string.match(line, "(%d+),(%d+),(%d+),(%d+),(%d+)")
  --
  --       x, y, z, typ, tim = tonumber(y), tonumber(z), tonumber(x), tonumber(typ), tonumber(tim)
  --
  --       stateChanges[tim] = stateChanges[tim] or {}
  --       stateChanges[tim][z] = stateChanges[tim][z] or {}
  --       stateChanges[tim][z][#stateChanges[tim][z] + 1] = {x = x, y = y, typ = typ}
  --       maxFrames = math.max(maxFrames, tim)
  --     end
  --     changes = changes + 1
  --   end
  --   if sim then
  --     sim.stateChanges = stateChanges
  --   end
  --
  --   display.playBack = 0
  --   display.maxFrames = maxFrames
  --
  --   sim = simulation({size = size, initState = initState, stateChanges = stateChanges})
  --   sim.init()
  --   sim.reset()
  -- end
  -- if string.find(filename, "ChangeState") then
  --
  --
  --   -- _G.menu.refresh()
  --
  -- end
end

function love.update(dt)

  testStack.update(dt)

  gui.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(50, 50, 50, 255)

  testStack.draw()

  gui.draw()

  console.draw()
end
