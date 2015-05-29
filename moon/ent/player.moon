export Player

class Player extends Entity
	new: (@xpos, @ypos) =>
		--setup
		super @xpos, @ypos
		@w = 32
		@h = 32
		@spd = 3
		@shot = false

		--collision group
		mad\setCollisionGroup(@, col.player)

	update: (dt) =>
		--key input
		if mad.input\key("left")
			if mad.col\checkCol(@, @x-@spd, @y, col.wall) == 0
				@x -= @spd
		if mad.input\key("right")
			if mad.col\checkCol(@, @x+@spd, @y, col.wall) == 0
				@x += @spd
		if mad.input\key("up")
			if mad.col\checkCol(@, @x, @y-@spd, col.wall) == 0
				@y -= @spd
		if mad.input\key("down")
			if mad.col\checkCol(@, @x, @y+@spd, col.wall) == 0
				@y += @spd

		--shooting
		if mad.input\key("z")
			if not @shot
				mad.object\createEnt(Bullet(@x + @w / 2, @y))
				@shot = true
		else
			@shot = false

		super self

	draw: =>
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", @x, @y, @w, @h)
