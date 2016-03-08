local settings = {
  -- {
  --   label = "Fullscreen", class = "checkbox",
  --   check = function(checked)
  --     love.window.setFullscreen(checked, "desktop")
  --     if not checked then
  --       local conf = {window = {}, modules = {}}
  --       love.conf(conf)
  --       love.window.setMode(conf.window.width, conf.window.height)
  --       love.resize(conf.window.width, conf.window.height)
  --     end
  --   end,
  --   isChecked = function()
  --     return love.window.getFullscreen()
  --   end
  -- },
  {
    label = "Layer Transparency", class = "slider",
    minValue = 0, maxValue = 100,
    slide = function(value)
      display.layerAlpha = value / 100
    end,
    getValue = function()
      return display.layerAlpha * 100
    end,
  },
  {
    label = "Layer Spread", class = "slider",
    minValue = 0, maxValue = 100,
    slide = function(value)
      display.layerSpread = value / 100
    end,
    getValue = function()
      return display.layerSpread * 100
    end,
  },
  {
    label = "Playback", class = "slider",
    minValue = 0,
    maxValue = function()
      return display.maxFrames
    end,
    slide = function(value)
      display.playBack = value
    end,
    getValue = function()
      return display.playBack
    end,
  },
}

function configuration(p)
  p = panel(p)

  local sh = 18

  for i, setting in ipairs(settings) do
    local pan = {
      x = p.w * 0.1,
      y = p.h * 0.15 + sh * (i - 1),
      w = 500,
      h = sh,
      font = cache.get.font("fonts/Rubik-Regular.ttf", 14),
      text = setting.label,
      check = setting.check,
      slide = setting.slide,
      minValue = setting.minValue,
      maxValue = setting.maxValue,
    }
    if setting.isChecked then
      pan.checked = setting.isChecked()
    end
    if setting.getValue then
      pan.slideValue = setting.getValue()
    end
    p.add(_G[setting.class](pan))
  end

  return p
end
