math.randomseed(os.time())
math.random()
math.random()
math.random()
math.random()

function math.sign(x)
  return x > 0 and 1 or -1
end

function math.clamp(v, l, h)
  return math.min(math.max(v, l), h)
end

function math.randomf(l, h)
  return l + math.random() * (h - l)
end

function math.randomn(mean, sd)
  return math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) * sd + mean
end

function math.len2(x, y)
  return math.sqrt(x * x + y * y)
end

function math.len3(x, y, z)
  return math.sqrt(x * x +  y * y + z * z)
end

function math.normalize2(x, y)
  local len = math.sqrt(x * x + y * y)
  if len == 0 then len = 1 end
  return x / len, y / len
end

function math.normalize3(x, y, z)
  local len = math.sqrt(x * x + y * y + z * z)
  if len == 0 then len = 1 end
  return x / len, y / len, z / len
end

function math.dot2(x1, y1, x2, y2)
  return x1 * x2 + y1 * y2
end

function math.dot3(x1, y1, z1, x2, y2, z2)
  return x1* x2 + y1 * y2 + z1 * z2
end

function math.cross3(ax, ay, az, bx, by, bz)
  return (ay * bz) - (az * by), -((ax * bz) - (az * bx)), (ax * by) - (ay * bx)
end

function math.distance2(x0, y0, x1, y1)
  return math.len2(x0 - x1, y0 - y1)
end

function math.distanceFromLine(x0, y0, x1, y1, x2, y2)
  return math.abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1) / math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function math.lerp(a, b, t)
  return a + (b - a) * t
end

function math.lerp2(x1, y1, x2, y2, t)
  return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
end

function math.lerp3(x1, y1, z1, x2, y2, z2, t)
  return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t, z1 + (z2 - z1) * t
end

function math.alerp(a, b, t)
  local slerp = vec(math.cos(a), math.sin(a)).slerp(vec(math.cos(b), math.sin(b)), t)
	return math.atan2(slerp.y, slerp.x)
end

-- Interpolation between normal vectors.
function math.slerp(x1, y1, x2, y2, t)
  -- Compute the cosine of the angle between the two vectors.
  local dot = math.dot2(x1, y1, x2, y2)

  -- If the inputs are too close for comfort, linearly interpolate
  -- and normalize the result.
  if dot > 0.9999 then
    return math.normalize2(math.lerp2(x1, y1, x2, y2, t))
  end

  -- Robustness: Stay within domain of acos()
  -- theta_0 = angle between input vectors
  local theta_0 = math.acos(math.min(math.max(dot, -0.999), 1))
  local cof0 = math.sin((1 - t) * theta_0) / math.sin(theta_0)
  local cof1 = math.sin(t * theta_0) / math.sin(theta_0)

  return math.normalize2(x1 * cof0 + x2 * cof1, y1 * cof0 + y2 * cof1)
end

function math.rotate(x, y, ang)
  local cs, sn = math.cos(ang), math.sin(ang)
  return x * cs - y * sn, x * sn + y * cs
end

function math.squeeze4(s, a, b, c, d)
  return math.floor(a) + math.floor(b) * s + math.floor(c) * s * s + math.floor(d) * s * s * s
end

function math.unsqueeze4(s, v)
  local s2, s3 = s * s, s * s * s
  local a = math.floor(v / s3)
  local b = math.floor((v - a * s3) / s2)
  local g = math.floor((v - a * s3 - b * s2) / s)
  -- return v % s, 0, 0, 255
  return v % s, g, b, a
end

function math.reumannWitkam(points, epsilon)
  local function get(i)
    return points[1 + i * 2], points[1 + i * 2 + 1]
  end
  local function remove(i)
    table.remove(points, 1 + i * 2)
    table.remove(points, 1 + i * 2)
  end
  local function length()
    return floor(table.count(points) / 2)
  end

  local key = 0

  while key < length() - 3 do
    local test = key + 2
    local p0x, p0y = get(test)
    local p1x, p1y = get(key)
    local p2x, p2y = get(key + 1)

    while test < length() and math.distanceFromLine(p0x, p0y, p1x, p1y, p2x, p2y) < epsilon do
      test = test + 1
      p0x, p0y = points[test * 2], points[test * 2 + 1]
    end

    for i = key + 1, test - 2 do
      remove(i)
    end

    key = key + 1
  end

  return points
end

function math.distanceSimplify(points, epsilon)
  local result = {}
  local len = table.count(points)

  local keyx, keyy = points[1], points[2]

  for i = 1, len - 3, 2 do
    local px, py = points[i], points[i + 1]
    local dist = math.len2(px - keyx, py - keyy)
    if dist > epsilon then
      result[#result + 1] = px
      result[#result + 1] = py
      keyx, keyy = px, py
    end
  end

  result[#result + 1] = points[len - 1]
  result[#result + 1] = points[len]

  return result
end

function math.douglasPeucker(points, epsilon)
  -- Find the point with the maximum distance
  local dmax = 0
  local index = 0
  local len = table.count(points)

  local p1x, p1y = points[1], points[2]
  local p2x, p2y = points[len - 1], points[len]

  for i = 3, len - 1, 2 do
    local p0x, p0y = points[i], points[i + 1]

    local d = math.distanceFromLine(p0x, p0y, p1x, p1y, p2x, p2y)
    if d > dmax then
      index = i
      dmax = d
    end
  end

  -- If max distance is greater than epsilon, recursively simplify
  local results = {}
  if dmax > epsilon then
    local recResults1 = math.douglasPeucker(table.sub(points, 1, index + 1), epsilon)
    local recResults2 = math.douglasPeucker(table.sub(points, index + 2, len), epsilon)
    results = table.join(recResults1, recResults2)
  else
    results = {p1x, p1y, p2x, p2y}
  end
  return results
end
