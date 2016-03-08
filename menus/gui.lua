local p = {}

p.root = panel({})

function p.draw()
  p.root.draw()
end

function p.update(dt)
  p.root.update(dt)
end

function p.mousePressed(x, y, button)
  p.root.mousePressed(x, y, button)
end

function p.mouseReleased(x, y, button)
  p.root.mouseReleased(x, y, button)
end

function p.mouseMove(x, y, dx, dy)
  return p.root.mouseMove(x, y, dx, dy)
end

gui = p
