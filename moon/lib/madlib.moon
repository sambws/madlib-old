--madlib
--requires everything in the lib folder, is required by main.moon

require "lib.require"
require "lib.TEsound" --sound
anim8 = require "lib.anim8" --animation
export camera = require "lib.camera" --camera

--WORKING
	--room system/persistence
	--entities
	--key input
	--game controller input
	--zording
	--basic collision functions
	--camera
	--really basic entity mapper
--TODO
	--work on the entity mapper
	--STI STI STI STI!!!!!!!
	--in-game debug console???

--controllas
export joysticks = love.joystick.getJoysticks()

--debug mode
export debug = true

--rooms
export room = ""
export switch_room = false

--lib
export entAmt = 0
export ents = {}
export gui = {}
export mad = {

	--startup
	init: =>
		--setup camera
		export cam = camera(0, 0, 1)
		mad.cam\look(cam, 0, 0)

	--will update both gui and ent tables
	update: (dt) =>
		--ent code
		for k, v in pairs ents
			if v.update ~= nil then v\update(dt)
		--gui code
		for k, v in pairs gui
			if v.update ~= nil then v\update(dt)
		--run all room code
		for k, v in pairs room_reg
			mad.room\runRoom(v.name, v.event)

	--drawing. takes a table to draw and an optional camera to draw them to
	draw: (tab, cam) =>
		--is there a camera?
		cam = cam or nil

		--zorder them up
		if tab == ents then
			if not switch_room then
				table.sort(tab, @drawSort)

		--draw em
		for k, v in pairs tab
			if v.draw ~= nil then 
				if cam then
					cam\attach()
					v\draw!
					cam\detach()
				else
					v\draw!

		--debuggin'
		if debug then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.print("FPS: " .. love.timer.getFPS(), 16, 16)
			love.graphics.print("amount of entities: " .. entAmt, 16, 32)

	--reorganizes the table based off of the ents' z value
	drawSort: (a, b) -> 
		if a and b
			if a.z and b.z
				return a.z > b.z

	--entities
	object:
	
		--will put a new class into the game
		createEnt: (ent) =>
			table.insert(ents, ent)
			if ent.new ~= nil then ent\new()
			entAmt += 1

			if debug then print("created ent ", ent)

		--inserts an object into the gui table
		createGUI: (ent) =>
			table.insert(gui, ent)
			if ent.new ~= nil then ent\new()

			if debug then print("created gui ", ent)

		--weird and probably doensn't work
		removeEnt: (ent) =>
			for k, v in pairs ents
				if v == ent then
					--run actions
					if v.destroy ~= nil then ent\destroy()
					entAmt -= 1

					--make the entity nil
					ents[k] = nil

					--debug
					if debug then print("removed ent", v)

	--drawing and animating
	sprite:
		--returns a basic image from a path
		img: (img_name) =>
			return love.graphics.newImage(path.img .. img_name)

		--sets up a grid for an image
		grid: (image, frame_width, frame_height) =>
			return anim8.newGrid(frame_width, frame_height, image\getWidth(), image\getHeight())

		--sets up an image with a grid for animation
		gImg: (image_name, frame_width, frame_height) =>
			i = love.graphics.newImage(path.img .. image_name)
			g = anim8.newGrid(frame_width, frame_height, i\getWidth(), i\getHeight())
			return i, g

		--defines an animation
		anim: (grid, frames, row, speed) =>
			return anim8.newAnimation(grid(frames, row), speed)

		--zord ents (called in base)
		zord: (s, mod) =>
			mod = mod or 0
			s.z = -s.y - (s.h) + mod

	--what the player will input to the game
	input:
		--basic keyboard keys
		key: (key_code) =>
			if love.keyboard.isDown(key_code) then
				return true
			else
				return false

		--get gamepad button down
		joyButton: (controller, button) =>
			if controller\isGamepadDown(button) then
				return true
			else
				return false

		--get axis of gamepad
		joyAxis: (controller, axis) =>
			return controller\getAxis(axis)

		--check if there's a certain controller connected
		joyConnected: (controller) =>
			if joysticks[controller] ~= nil
				return true
			else
				return false

		--get controller list
		getControllers: =>
			a = love.joystick.getJoysticks()
			return a

	--rooms
	room:
		--set room
		switchRoom: (new_room) =>
			--delete everything non-persistent
			for k, v in pairs (ents)
    			if v.persistent == false
    				mad.object\removeEnt(v)
    			else
    				if debug then print(v, "is persistent")
    		--set room; run code
			room = new_room
			switch_room = true
			if debug then print("switched room to " .. new_room)

		--run room creation func
		runRoom: (new_room, func) =>
			if switch_room
				if room == new_room
					func!
					if debug then print("finished creating objects for " .. room)
					switch_room = false

	--sound functionality
	audio:
		--plays a sound
		playSound: (sound, tags, velocity, pitch) =>
			velocity = velocity or 1
			pitch = pitch or 1
			TEsound.play(path.snd .. sound, tags, velocity, pitch)

		--loop sound
		loopSound: (sound, tags, loops, velocity, pitch) =>
			velocity = velocity or 1
			pitch = pitch or 1
			loops = loops or 1
			TEsound.playLooping(path.snd .. sound, tags, loops, velocity, pitch)

	--some random camera functions i guess
	cam:
		look: (cam, x, y) =>
			ox, oy = cam\cameraCoords(x, y)
			cam\lookAt(ox, oy)

	--math stuff
	math:
		clamp: (low, n, high) ->
			return math.min(math.max(low, n), high)
			
		lerp: (a,b,t) ->
			return (1-t)*a + t*b

	col:
		--will return how many objects of a given tag are within an object's boundingbox
		colList: (s, x, y, collision_group) =>
			list = {}
			for k, v in pairs ents
				if v.col == collision_group and v ~= s then
					if @boundingBox(x, y, s, v) then
						table.insert(list, v)
			return list

		--check if object is overlapping other object
		boundingBox: (x, y, o, o2) =>
			return x < o2.x+o2.w and o2.x < x+o.w and y < o2.y+o2.h and o2.y < y+o.h

		--will automatically return the size of a colList
		checkCol: (s, x, y, collision_group) =>
			return #@colList(s, x, y, collision_group)


	--set col group for ent
	setCollisionGroup: (o, g) =>
		o.col = g

	--kinda useless; polls object to see if it can access this lib			
	test: =>
		print("madlib is working for the polled object")

}

--base entity class; has some base functionality
export class Entity
	new: (@xpos, @ypos) =>
		@x = @xpos
		@y = @ypos
		@z = -@ypos
		@persistent = false

	update: (dt) =>
		mad.sprite\zord(self)