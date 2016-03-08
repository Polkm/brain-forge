require("menus/configuration")

local function menu(p)
  p.w = love.graphics.getWidth()
  p.h = love.graphics.getHeight()
  p = panel(p)

  function p.open()
    gui.root.add(p)
  end

  function p.refresh()
    _G.menu.close()
    _G.menu = menu({})
    _G.menu.open()
  end

  p.configuration = configuration({
    x = p.w * 0.5,
  })
  p.add(p.configuration)

  return p
end

_G.menu = menu({})
_G.menu.open()

function love.resize(w, h)
  _G.menu.refresh()
end
