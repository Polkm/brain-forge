color = {}

function color.hsv(H, S, V)
  if S <= 0 then return V, V, V end
  H, S, V = (H % 255) / 255 * 6, math.max(math.min(S, 255), 0) / 255, math.max(math.min(V, 255), 0) / 255
  local C = V * S
  local X = (1 - math.abs((H % 2) - 1)) * C
  local m, R, G, B = (V - C), C, 0, X

  if H < 1 then R, G, B = C, X, 0
  elseif H < 2 then R, G, B = X, C, 0
  elseif H < 3 then R, G, B = 0, C, X
  elseif H < 4 then R, G, B = 0, X, C
  elseif H < 5 then R, G, B = X, 0, C
  end
  return (R + m) * 255, (G + m) * 255, (B + m) * 255
end

function color.mult(s, r, g, b, a)
  return r * s, g * s, b * s, a
end

function color.normalColor(x, y, z)
  -- return (x) * 255, (y) * 255, (z) * 255
  return (x / 2 + 0.5) * 255, (y / 2 + 0.5) * 255, (z / 2 + 0.5) * 255
end
