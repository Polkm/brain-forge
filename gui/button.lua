function button(p)
  p = panel(p)

  function p.drawBack()
    love.graphics.setColor(255, 255, 255, p.hover and 255 or 0)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
  end



  return p
end
