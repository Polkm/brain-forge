function menubutton(p)
  p = panel(p)

  function p.drawBack()
    love.graphics.setColor(255, 255, 255, (p.hover and p.parent.subMenuOpen) and 255 or 0)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h, 3, 3)
    love.graphics.rectangle("fill", p.x, p.y + p.h - 3, p.w, 3, 0, 0)
  end

  function p.drawFront()
    if (p.hover and p.parent.subMenuOpen) then
      love.graphics.setColor(40, 40, 40, 255)
    else
      love.graphics.setColor(220, 220, 220, 255)
    end
    love.graphics.setFont(p.font)
    local y = (p.h - p.font:getHeight()) * 0.5
    love.graphics.printf(p.text, p.x, p.y + y - 1, p.w, p.align)
  end

  function p.clicked(x, y, button)
    p.parent.subMenuOpen = not p.parent.subMenuOpen

  end



  return p
end
