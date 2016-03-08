function table.count(tbl)
  local count = 0
  for k, v in pairs(tbl) do count = count + 1 end
  return count
end

-- Returns a random value from the table
function table.random(tbl)
  if type(tbl) ~= "table" then return end

  local count = table.count(tbl)
  if count <= 0 then return end

  local rndKey = math.random(1, count)
  local i = 1
  for k, v in pairs(tbl) do
    if i == rndKey then return v end
    i = i + 1
  end
end

function table.expel(tbl, value)
  for k, v in pairs(tbl) do
    if v == value then
      tbl[k] = nil
    end
  end
end

function table.randomw(tbl, weights)
  local ran = math.random()
  local sum = 0
  for k, v in pairs(weights) do
    if ran > sum and ran <= sum + v then
      return tbl[k]
    end
    sum = sum + v
  end
end

function table.sub(tbl, l, h)
  local rtbl = {}
  for i = l, h do
    rtbl[#rtbl + 1] = tbl[i]
  end
  return rtbl
end

function table.join(tbl1, tbl2)
  local rtbl = {}
  for i, v in ipairs(tbl1) do
    table.insert(rtbl, v)
  end
  for i, v in ipairs(tbl2) do
    table.insert(rtbl, v)
  end
  return rtbl
end

local function deafultSort(a, b) return a > b end
function table.insertSort(tbl, func)
  func = func or deafultSort
  local len = #tbl
  for j = 2, len do
    local key, i = tbl[j], j - 1
    while i > 0 and not func(tbl[i], key) do
      tbl[i + 1] = tbl[i]
      i = i - 1
    end
    tbl[i + 1] = key
  end
  return tbl
end
