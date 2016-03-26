require("menus/configuration")

local function interface(p)
  p.w = love.graphics.getWidth()
  p.h = love.graphics.getHeight()
  p = panel(p)

  function p.open()
    gui.root.add(p)
  end

  function p.refresh()
    _G.interface.close()
    _G.interface = interface({})
    _G.interface.open()
  end

  p.mainMenuBar = menubar({
    x = 0, y = 0, w = love.graphics.getWidth(), h = 22
  })
  p.mainMenuBar.addMenu({text = "File", dropdown = {
    {text = "New Model", hotkey = {"lctrl", "n"}, func = function()  end},
    {text = "Open", hotkey = {"lctrl", "o"}, func = function()  end},
    {text = "Save", hotkey = {"lctrl", "s"}, func = function()  end},
    {text = "Import", func = function()  end},
    {text = "Export", dropdown = {
      {text = "JSON", func = function()  end},
      {text = "Lua", func = function()  end},
      {text = "CSV", func = function()  end},
      {text = "Binary", func = function()  end},
    }},
    "divider",
    {text = "Quit", func = function()  end},
  }})
  p.mainMenuBar.addMenu({text = "Edit", dropdown = {
    {text = "Undo", hotkey = {"lctrl", "z"}, func = function()  end},
    {text = "Redo", hotkey = {"lctrl", "y"}, func = function()  end},
    "divider",
    {text = "Cut", hotkey = {"lctrl", "x"}, func = function()  end},
    {text = "Copy", hotkey = {"lctrl", "c"}, func = function()  end},
    {text = "Paste", hotkey = {"lctrl", "v"}, func = function()  end},
    {text = "Select All", hotkey = {"lctrl", "a"}, func = function()  end},
    "divider",
    {text = "Preferences", hotkey = {"lctrl", ","}, func = function()  end},
  }})
  p.mainMenuBar.addMenu({text = "View"})
  p.mainMenuBar.addMenu({text = "Train", dropdown = {
    {text = "Export", dropdown = {
      {text = "JSON", func = function()  end},
      {text = "Lua", func = function()  end},
      {text = "CSV", func = function()  end},
      {text = "Binary", func = function()  end},
    }},
  }})
  p.mainMenuBar.addMenu({text = ""})
  p.add(p.mainMenuBar)

  p.configuration = configuration({
    x = p.w - 500, y = p.mainMenuBar.h
  })
  p.add(p.configuration)






  return p
end

_G.interface = interface({})
_G.interface.open()

function love.resize(w, h)
  _G.interface.refresh()
end
