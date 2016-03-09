local p = {}

function love.mousemoved(x, y, dx, dy)
  if not gui.mouseMove(x, y, dx, dy) then

    if p.simulation then
      if love.mouse.isDown(1) then
        p.simulation.volumeRotation = p.simulation.volumeRotation - dx / 100
        p.simulation.volumeTilt = math.min(math.max(p.simulation.volumeTilt - dy / 300, 0.02), math.pi * 0.48)
      end
      if love.mouse.isDown(2) then
        p.simulation.panX = p.simulation.panX + dx
        p.simulation.panY = p.simulation.panY + dy
      end
    end
  end
end

function love.mousepressed(x, y, button)
  gui.mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
  gui.mouseReleased(x, y, button)
end

function love.wheelmoved(x, y)
  if p.simulation then
    if y > 0 then
      p.simulation.volumeZoom = p.simulation.volumeZoom * 2
    elseif y < 0 then
      p.simulation.volumeZoom = p.simulation.volumeZoom / 2
    end
  end
end

function love.keyreleased(key)
  if p.simulation then
    if key == "r" then p.simulation.reset() end
    if key == "space" then p.simulation.paused = not p.simulation.paused end
  end
  if key == "g" then
    sim = simulation({})
    sim.init()
    sim.reset()
  end
end

controls = p
