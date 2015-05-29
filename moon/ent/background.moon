export Background

class Background extends Entity
	new: (@xpos, @ypos) =>
		super @xpos, @ypos
		@w = love.graphics.getWidth()
		@h = love.graphics.getHeight()
		@z = 1000

	update: (dt) =>

	draw: =>
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("fill", @x, @y, @w, @h)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(@z .. ", " .. @y, 0, 0)