local p = {}

function love.mousemoved(x, y, dx, dy)
  if not gui.mouseMove(x, y, dx, dy) then

    -- if p.simulation then
      if love.mouse.isDown(1) then
        display.rotation = display.rotation - dx / 100
        display.tilt = math.min(math.max(display.tilt - dy / 300, 0.02), math.pi * 0.48)
      end
      if love.mouse.isDown(2) then
        display.panX = display.panX + dx
        display.panY = display.panY + dy
      end
    -- end
  end
end

function love.mousepressed(x, y, button)
  gui.mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
  gui.mouseReleased(x, y, button)
end

function love.wheelmoved(x, y)
  -- if p.simulation then
    if y > 0 then
      display.zoom = display.zoom * 2
    elseif y < 0 then
      display.zoom = display.zoom / 2
    end
  -- end
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
