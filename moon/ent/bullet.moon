export Bullet

class Bullet extends Entity
	new: (@xpos, @ypos) =>
		super @xpos, @ypos
		@w=16
		@h=16
		@spd=3

	update: (dt) =>
		@y-=@spd

		if @y <= 0
			mad.object\removeEnt(self)

		super self

	draw: =>
		love.graphics.setColor(255, 0, 255, 255)
		love.graphics.rectangle("fill", @x, @y, @w, @h)