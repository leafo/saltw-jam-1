
require "lovekit.all"
require "lovekit.reloader"

{graphics: g} = love

export ^

class Bullet extends Entity
  lazy sprite: -> Spriter "images/disk.png", 32, 16, 1

  w: 2
  h: 2

  speed: 250

  new: (x,y, @dir=Vec2d(1, 0)) =>
    super x,y
    @anim = @sprite\seq {0, 1, 2}, 0.1

  update: (dt) =>
    @move unpack @speed * dt * @dir
    @anim\update dt
    true

  draw: =>
    @anim\draw @x, @y

class Player extends Entity
  lazy sprite: -> Spriter "images/player.png"

  w: 10
  h: 10

  speed: 80

  new: (...) =>
    super ...

    with @sprite
      dldr = {
        "100,2,27,32"
        "100,40,27,32"
        "100,79,27,32"

        "100,116,27,32"
        "100,154,27,32"
        "100,192,27,32"
      }

      lr = {
        "34,2,27,32"
        "34,40,27,32"
        "34,78,27,32"

        "34,116,27,32"
        "34,154,27,32"
        "34,192,27,32"
      }

      uldr = {
        "127,2,27,32"
        "127,40,27,32"
        "127,78,27,32"

        "127,116,27,32"
        "127,154,27,32"
        "127,192,27,32"
      }

      @anim = StateAnim "walk_ur", {
        -- stand: \seq {"4,3,27,32"}
        walk_d: \seq {
          "4,2,27,32"
          "4,40,27,32"
          "4,78,27,32"

          "4,116,27,32"
          "4,154,27,32"
          "4,192,27,32"
        }, 150/1000


        walk_r: \seq lr, 150/1000
        walk_l: \seq lr, 150/1000, true

        walk_u: \seq {
          "70,2,27,32"
          "70,40,27,32"
          "70,78,27,32"

          "70,116,27,32"
          "70,154,27,32"
          "70,192,27,32"
        }, 150/1000

        walk_dl: \seq dldr, 150/1000
        walk_dr: \seq dldr, 150/1000, true


        walk_ul: \seq uldr, 150/1000
        walk_ur: \seq uldr, 150/1000, true
      }

      @anim\splice_states {1}, (name) -> name\gsub "walk", "stand"
      @anim\set_state "stand_d"
      @face_dir = Vec2d(0, 1)

  update: (dt) =>
    move = movement_vector!
    @move unpack move * @speed * dt

    if move\is_zero!
      if @last_direction
        @anim\set_state "stand_" .. @last_direction
    else
      {dx, dy} = move

      lr = if dx < 0
        "l"
      elseif dx > 0
        "r"
      else
        ""

      ud = if dy < 0
        "u"
      elseif dy > 0
        "d"
      else
        ""

      @face_dir = move\normalized!
      @last_direction = ud .. lr
      @anim\set_state "walk_" .. @last_direction, 2

    @anim\update dt
    true

  draw: =>
    @anim\draw @x, @y
    COLOR\push 255,128,128,128
    Box.draw @
    COLOR\pop!

  shoot: (world) =>
    world.entities\add Bullet @x, @y, @face_dir\dup!

class Game
  new: =>
    @viewport = Viewport scale: 2
    @player = Player 10, 10

    @entities = with DrawList!
      \add @player

  draw: =>
    @viewport\apply!

    g.print "Hello World Welcome to My Game", 10, 10
    @entities\draw!
    @viewport\pop!

  update: (dt) =>
    @entities\update dt

  on_key: (key) =>
    if key == "z"
      @player\shoot @

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

