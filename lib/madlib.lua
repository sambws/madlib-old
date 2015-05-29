require("lib.require")
require("lib.TEsound")
local anim8 = require("lib.anim8")
camera = require("lib.camera")
joysticks = love.joystick.getJoysticks()
debug = true
room = ""
switch_room = false
entAmt = 0
ents = { }
gui = { }
mad = {
  init = function(self)
    cam = camera(0, 0, 1)
    return mad.cam:look(cam, 0, 0)
  end,
  update = function(self, dt)
    for k, v in pairs(ents) do
      if v.update ~= nil then
        v:update(dt)
      end
    end
    for k, v in pairs(gui) do
      if v.update ~= nil then
        v:update(dt)
      end
    end
    for k, v in pairs(room_reg) do
      mad.room:runRoom(v.name, v.event)
    end
  end,
  draw = function(self, tab, cam)
    cam = cam or nil
    if tab == ents then
      if not switch_room then
        table.sort(tab, self.drawSort)
      end
    end
    for k, v in pairs(tab) do
      if v.draw ~= nil then
        if cam then
          cam:attach()
          v:draw()
          cam:detach()
        else
          v:draw()
        end
      end
    end
    if debug then
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.print("FPS: " .. love.timer.getFPS(), 16, 16)
      return love.graphics.print("amount of entities: " .. entAmt, 16, 32)
    end
  end,
  drawSort = function(a, b)
    if a and b then
      if a.z and b.z then
        return a.z > b.z
      end
    end
  end,
  object = {
    createEnt = function(self, ent)
      table.insert(ents, ent)
      if ent.new ~= nil then
        ent:new()
      end
      entAmt = entAmt + 1
      if debug then
        return print("created ent ", ent)
      end
    end,
    createGUI = function(self, ent)
      table.insert(gui, ent)
      if ent.new ~= nil then
        ent:new()
      end
      if debug then
        return print("created gui ", ent)
      end
    end,
    removeEnt = function(self, ent)
      for k, v in pairs(ents) do
        if v == ent then
          if v.destroy ~= nil then
            ent:destroy()
          end
          entAmt = entAmt - 1
          ents[k] = nil
          if debug then
            print("removed ent", v)
          end
        end
      end
    end
  },
  sprite = {
    img = function(self, img_name)
      return love.graphics.newImage(path.img .. img_name)
    end,
    grid = function(self, image, frame_width, frame_height)
      return anim8.newGrid(frame_width, frame_height, image:getWidth(), image:getHeight())
    end,
    gImg = function(self, image_name, frame_width, frame_height)
      local i = love.graphics.newImage(path.img .. image_name)
      local g = anim8.newGrid(frame_width, frame_height, i:getWidth(), i:getHeight())
      return i, g
    end,
    anim = function(self, grid, frames, row, speed)
      return anim8.newAnimation(grid(frames, row), speed)
    end,
    zord = function(self, s, mod)
      mod = mod or 0
      s.z = -s.y - (s.h) + mod
    end
  },
  input = {
    key = function(self, key_code)
      if love.keyboard.isDown(key_code) then
        return true
      else
        return false
      end
    end,
    joyButton = function(self, controller, button)
      if controller:isGamepadDown(button) then
        return true
      else
        return false
      end
    end,
    joyAxis = function(self, controller, axis)
      return controller:getAxis(axis)
    end,
    joyConnected = function(self, controller)
      if joysticks[controller] ~= nil then
        return true
      else
        return false
      end
    end,
    getControllers = function(self)
      local a = love.joystick.getJoysticks()
      return a
    end
  },
  room = {
    switchRoom = function(self, new_room)
      for k, v in pairs((ents)) do
        if v.persistent == false then
          mad.object:removeEnt(v)
        else
          if debug then
            print(v, "is persistent")
          end
        end
      end
      room = new_room
      switch_room = true
      if debug then
        return print("switched room to " .. new_room)
      end
    end,
    runRoom = function(self, new_room, func)
      if switch_room then
        if room == new_room then
          func()
          if debug then
            print("finished creating objects for " .. room)
          end
          switch_room = false
        end
      end
    end
  },
  audio = {
    playSound = function(self, sound, tags, velocity, pitch)
      velocity = velocity or 1
      pitch = pitch or 1
      return TEsound.play(path.snd .. sound, tags, velocity, pitch)
    end,
    loopSound = function(self, sound, tags, loops, velocity, pitch)
      velocity = velocity or 1
      pitch = pitch or 1
      loops = loops or 1
      return TEsound.playLooping(path.snd .. sound, tags, loops, velocity, pitch)
    end
  },
  cam = {
    look = function(self, cam, x, y)
      local ox, oy = cam:cameraCoords(x, y)
      return cam:lookAt(ox, oy)
    end
  },
  math = {
    clamp = function(low, n, high)
      return math.min(math.max(low, n), high)
    end,
    lerp = function(a, b, t)
      return (1 - t) * a + t * b
    end
  },
  col = {
    colList = function(self, s, x, y, collision_group)
      local list = { }
      for k, v in pairs(ents) do
        if v.col == collision_group and v ~= s then
          if self:boundingBox(x, y, s, v) then
            table.insert(list, v)
          end
        end
      end
      return list
    end,
    boundingBox = function(self, x, y, o, o2)
      return x < o2.x + o2.w and o2.x < x + o.w and y < o2.y + o2.h and o2.y < y + o.h
    end,
    checkCol = function(self, s, x, y, collision_group)
      return #self:colList(s, x, y, collision_group)
    end
  },
  setCollisionGroup = function(self, o, g)
    o.col = g
  end,
  test = function(self)
    return print("madlib is working for the polled object")
  end
}
do
  local _base_0 = {
    update = function(self, dt)
      return mad.sprite:zord(self)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, xpos, ypos)
      self.xpos, self.ypos = xpos, ypos
      self.x = self.xpos
      self.y = self.ypos
      self.z = -self.ypos
      self.persistent = false
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
end
