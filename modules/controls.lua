local p = {}

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    p.simulation.volumeRotation = p.simulation.volumeRotation - dx / 100
    p.simulation.volumeTilt = math.min(math.max(p.simulation.volumeTilt - dy / 300, 0.02), math.pi * 0.48)
  end
  if love.mouse.isDown(2) then
    p.simulation.panX = p.simulation.panX + dx
    p.simulation.panY = p.simulation.panY + dy
  end
end

function love.wheelmoved(x, y)
  if y > 0 then
    p.simulation.volumeZoom = p.simulation.volumeZoom * 2
  elseif y < 0 then
    p.simulation.volumeZoom = p.simulation.volumeZoom / 2
  end
end

function love.keyreleased(key)
  if key == "r" then p.simulation.reset() end
  if key == "space" then p.simulation.paused = not p.simulation.paused end
end


controls = p
