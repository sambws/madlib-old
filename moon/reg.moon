--this file is like a global registry for random stuff you might need throughout your project.
--any entity can aquire these things, and the file itself is required from main.moon

export col, path

--set up controllers here
export joystick = joysticks[1]

--collision groups
col = {
	player: 0
	wall: 1
	--add more collision groups here!
}

--resource paths
path = {
	img: "res/img/"
	snd: "res/snd/"
	dat: "res/dat/"
	--add any other external resource paths here!
}

export loadLevel = (filename) ->
	fn = path.dat .. filename .. ".txt"
	love.filesystem.load(fn)()