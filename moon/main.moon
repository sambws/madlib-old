--stuff to require; madlib, data registry, entities
require "lib.madlib"
require "reg"
require.tree "ent"

--room registry
export room_reg = {
	start: {
		name: "start"
		event: =>
			loadLevel("stage")
			mad.object\createEnt(Background(0, 0))
			mad.object\createEnt(Player(64, 64))
	}
	--register other rooms here
}

love.load = ->
	--init stuff
	mad\init!

	--switch the room
	mad.room\switchRoom("start")

love.update = (dt) ->
	--update all ents
	mad\update(dt)

love.draw = ->
	--draw all ents
	mad\draw(ents, cam)
	mad\draw(gui)

love.timer.sleep = ->