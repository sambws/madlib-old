joystick = joysticks[1]
col = {
  player = 0,
  wall = 1
}
path = {
  img = "res/img/",
  snd = "res/snd/",
  dat = "res/dat/"
}
loadLevel = function(filename)
  local fn = path.dat .. filename .. ".txt"
  return love.filesystem.load(fn)()
end
