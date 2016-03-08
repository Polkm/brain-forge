function checkbox(p)
  p = panel(p)

  p.checked = p.checked or false
  p.boxSize = p.font:getHeight()

  function p.drawBack()
    love.graphics.setColor(255, 255, 255, 20)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
  end

  function p.drawFront()
    if p.text then
      love.graphics.setColor(255, 255, 255, 255)
      if p.font then
        love.graphics.setFont(p.font)
      end
      love.graphics.printf(p.text, p.x + p.boxSize * 1.5, p.y, p.w, "left")
    end

    love.graphics.rectangle("line", p.x, p.y, p.boxSize, p.boxSize)

    if p.checked then
      love.graphics.rectangle("fill", p.x + p.boxSize * 0.15, p.y + p.boxSize * 0.15, p.boxSize * 0.7, p.boxSize * 0.7)
    end

  end

  p.check = p.check or function(checked)

  end

  function p.clicked(x, y, button)
    p.checked = not p.checked
    p.check(p.checked)
  end



  return p
end
