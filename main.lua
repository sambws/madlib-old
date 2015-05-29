require("lib.madlib")
require("reg")
require.tree("ent")
room_reg = {
  start = {
    name = "start",
    event = function(self)
      loadLevel("stage")
      mad.object:createEnt(Background(0, 0))
      return mad.object:createEnt(Player(64, 64))
    end
  }
}
love.load = function()
  mad:init()
  return mad.room:switchRoom("start")
end
love.update = function(dt)
  return mad:update(dt)
end
love.draw = function()
  mad:draw(ents, cam)
  return mad:draw(gui)
end
love.timer.sleep = function() end
