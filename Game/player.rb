require 'gosu'

include Gosu

class Player
  def initialize
    @image = Gosu::Image.new("../assets/images/gorf.png")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
  end

  def update

  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def move
    @x += @vel_x
    @y += @vel_y
  end
end