function panel(p)
  p.x, p.y = p.x or 0, p.y or 0
  p.w, p.h = p.w or 100, p.h or 12
  p.text = p.text --or ""
  p.children = p.children or {}
  p.parent = p.parent or nil
  p.dragging = p.dragging or false

  function p.add(child)
    if child.parent then
      child.parent.remove(child)
    end
    table.insert(p.children, child)
    child.parent = p
  end

  function p.remove(child)
    table.expel(p.children, child)
    child.parent = nil
  end

  function p.close()
    if p.parent then
      p.parent.remove(p)
    end
  end

  function p.getScreenPos()
    local x, y = p.x, p.y
    if p.parent then
      x, y = x + p.parent.x, y + p.parent.y
    end
    return x, y
  end

  p.drawBack = p.drawBack or function()
    -- love.graphics.setColor(255, 255, 255, 100)
    -- love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
  end

  p.drawFront = p.drawFront or function()
    if p.text then
      love.graphics.setColor(255, 255, 255, 255)
      if p.font then
        love.graphics.setFont(p.font)
      end
      love.graphics.printf(p.text, p.x, p.y, p.w, "left")
    end
  end

  function p.draw()
    if p.parent then
      love.graphics.push()
      love.graphics.translate(p.parent.x, p.parent.y)
    end
    p.drawBack()
    p.drawFront()

    for _, pan in pairs(p.children) do
      pan.draw()
    end
    if p.parent then
      love.graphics.pop()
    end
  end

  function p.update(dt)

    for _, pan in pairs(p.children) do
      pan.update(dt)
    end
  end

  p.clicked = p.clicked or function(x, y, button)

  end

  function p.mousePressed(x, y, button)
    if p.hover then
      p.dragging = true
    end

    for _, pan in pairs(p.children) do
      pan.mousePressed(x, y, button)
    end
  end

  function p.mouseReleased(x, y, button)
    if p.hover then
      p.clicked(x, y, button)
    end

    p.dragging = false

    for _, pan in pairs(p.children) do
      pan.mouseReleased(x, y, button)
    end
  end

  p.drag = p.drag or function(x, y, dx, dy)
    return false
  end

  function p.mouseMove(x, y, dx, dy)
    local tx, ty = p.x, p.y--p.getScreenPos()
    if x >= tx and x <= tx + p.w and y >= ty and y <= ty + p.h then
      p.hover = true
    else
      p.hover = false
    end

    local using = false

    if p.dragging then
      if p.drag(x, y, dx, dx) then
        using = true
      end
    end

    for _, pan in pairs(p.children) do
      if pan.mouseMove(x - p.x, y - p.y, dx, dx) then
        using = true
      end
    end

    return using
  end

  return p
end
