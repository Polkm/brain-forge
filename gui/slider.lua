function slider(p)
  p = panel(p)

  p.checked = p.checked or false
  p.slideWidth = p.w * 0.5
  p.sliderHeight = p.font:getHeight()
  p.sliderWidth = p.sliderHeight * 2

  p.slideValue = p.slideValue or 0
  p.minValue = p.minValue or 0
  p.maxValue = p.maxValue or 1

  local function getMax()
    if type(p.maxValue) == "function" then
      return p.maxValue()
    else
      return p.maxValue
    end
  end

  local function getSliderX()
    local d = ((p.slideValue - p.minValue) / (getMax() - p.minValue))
    return d * (p.slideWidth - p.sliderWidth)
  end

  p.slide = p.slide or function(value)

  end

  p.slider = panel({
    x = getSliderX(),
    w = p.sliderWidth,
    h = p.sliderHeight,
    text = p.slideValue,
    drawBack = function()
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.rectangle("fill", p.slider.x, p.slider.y, p.sliderWidth, p.slider.h)
    end,
    drawFront = function()
      love.graphics.setColor(50, 50, 50, 255)
      love.graphics.printf(p.slider.text, p.slider.x, p.slider.y, p.slider.w, "center")
    end,
    drag = function(x, y, dx, dy)
      p.slider.x = math.clamp(p.slider.x + dx, 0, p.slideWidth - p.sliderWidth)

      local d = (p.slider.x) / (p.slideWidth - p.sliderWidth)

      p.slideValue = math.floor(math.lerp(p.minValue, getMax(), d) + 0.5)

      p.slider.text = p.slideValue

      p.slide(p.slideValue)

      return true
    end,
  })
  p.add(p.slider)

  function p.drawBack()
    love.graphics.setColor(255, 255, 255, 20)
    love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
  end

  function p.drawFront()
    love.graphics.setColor(255, 255, 255, 255)
    if p.text then
      if p.font then
        love.graphics.setFont(p.font)
      end
      love.graphics.printf(p.text, p.x + p.w * 0.52, p.y, p.w, "left")
    end

    love.graphics.rectangle("fill", p.x, p.y + p.sliderHeight * 0.5, p.slideWidth, 1)
  end

  return p
end
