require 'gosu'
require '../Game/input'
require '../Game/collidable'

class Player < Collidable
  def initialize(x, y)
    @image = Gosu::Image.new("../assets/images/gorf.png")
    super(x, y, @image)
    @x = x
    @y = y
    @angle = 0.0
  end

  def update
    if Input.button_pressed(Gosu::KB_W) or Input.button_pressed(Gosu::Button::KbUp)
      turn_up
      move
    elsif Input.button_pressed(Gosu::KB_A) or Input.button_pressed(Gosu::Button::KbLeft)
      turn_left
      move
    elsif Input.button_pressed(Gosu::KB_S) or Input.button_pressed(Gosu::Button::KbDown)
      turn_down
      move
    elsif Input.button_pressed(Gosu::KB_D) or Input.button_pressed(Gosu::Button::KbRight)
      turn_right
      move
    end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def on_collision(collider)
    puts "There was a collision"
  end

  def turn_up
    @angle = 0
  end

  def turn_down
    @angle = 180
  end

  def turn_left
    @angle = 270
  end

  def turn_right
    @angle = 90
  end

  def move
    _dx = Gosu.offset_x(@angle, 48)
    _dy = Gosu.offset_y(@angle, 48)
    @x += _dx
    @y += _dy

    @aabb.update(_dx, _dy)
  end
end