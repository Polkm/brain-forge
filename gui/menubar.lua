function menubar(p)
  p = panel(p)

  p.subMenuOpen = false

  function p.drawBack()
    love.graphics.setColor(60, 60, 65, 255)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
  end

  function p.addMenu(q)
    q.font = cache.get.font("fonts/Rubik-Regular.ttf", 14)
    -- q.font = cache.get.font("fonts/Rubik-Regular.ttf", p.h - 6)
    q.w = q.w or q.font:getWidth(q.text or "") + 15
    q.h = q.h or p.h
    q.x = p.getMax().x + 1
    q.align = "center"
    local nbutton = menubutton(q)
    p.add(nbutton)
  end

  return p
end
