
{graphics: g} = love

love.load = ->
  love.update = ->

  love.draw = ->
    g.print "Hello world", 10, 10

