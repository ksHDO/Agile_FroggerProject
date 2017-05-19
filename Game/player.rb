require 'gosu'
require '../Game/input'

class Player
  def initialize(x, y)
    @image = Gosu::Image.new("../assets/images/gorf.png")
    @x = x
    @y = y
    @vel_x = @vel_y = 3.0
    @angle = 0.0
  end

  def update
    if Input.button_down(Gosu::KB_W)
      turn_up
      move
    elsif Input.button_down(Gosu::KB_A)
      turn_left
      move
    elsif Input.button_down(Gosu::KB_S)
      turn_down
      move
    elsif Input.button_down(Gosu::KB_D)
      turn_right
      move
    end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
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
    @x += Gosu.offset_x(@angle, 5)
    @y += Gosu.offset_y(@angle, 5)
  end
end