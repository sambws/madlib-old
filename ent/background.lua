do
  local _parent_0 = Entity
  local _base_0 = {
    update = function(self, dt) end,
    draw = function(self)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
      love.graphics.setColor(0, 0, 0, 255)
      return love.graphics.print(self.z .. ", " .. self.y, 0, 0)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, xpos, ypos)
      self.xpos, self.ypos = xpos, ypos
      _parent_0.__init(self, self.xpos, self.ypos)
      self.w = love.graphics.getWidth()
      self.h = love.graphics.getHeight()
      self.z = 1000
    end,
    __base = _base_0,
    __name = "Background",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Background = _class_0
  return _class_0
end
