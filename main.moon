
require "lovekit.all"

{graphics: g} = love

export ^


class Game
  new: =>
    @viewport = Viewport scale: 3

  draw: =>
    @viewport\apply!
    g.print "Hello World Welcome to My Game", 10, 10
    @viewport\pop!

  update: (dt) =>

load_font = (img, chars)->
  font_image = imgfy img
  g.newImageFont font_image.tex, chars

love.load = ->
  export fonts = {
    default: load_font "images/font1.png", [[ ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?]]
  }

  g.setFont fonts.default
  g.setBackgroundColor 30,30,30


  export dispatch = Dispatcher Game!
  dispatch\bind love

