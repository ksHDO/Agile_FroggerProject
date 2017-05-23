require 'gosu'
require '../Game/input'

class Player
  def initialize(x, y)
    @image = Gosu::Image.new("../assets/images/gorf.png")
    @image_size = @image#height
    @x = x
    @y = y
    @angle = 0.0
  end

  def update
    if Input.button_down(Gosu::KB_W) or Input.button_down(Gosu::Button::KbUp)
      turn_up
      move
    elsif Input.button_down(Gosu::KB_A) or Input.button_down(Gosu::Button::KbLeft)
      turn_left
      move
    elsif Input.button_down(Gosu::KB_S) or Input.button_down(Gosu::Button::KbDown)
      turn_down
      move
    elsif Input.button_down(Gosu::KB_D) or Input.button_down(Gosu::Button::KbRight)
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

  def x
    @x
  end
  def y
    @y
  end
end