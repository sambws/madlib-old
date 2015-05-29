export Wall

class Wall extends Entity
	new: (@xpos, @ypos) =>
		--setup
		super @xpos, @ypos
		@w = 32
		@h = 32
		@z = 100

		--collision
		mad\setCollisionGroup(@, col.wall)

	update: (dt) =>

	draw: =>
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.rectangle("fill", @x, @y, @w, @h)