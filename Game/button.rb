require '../Game/collidable'

class Button
  include Collidable

  def initialize(x,y,image)
    @x = x
    @y = y
    @image = image
    init_collision(x,y,image)
  end

  def draw(opacity = 1)
    color = Gosu::Color.new(opacity * 255, 255, 255, 255)
    @image.draw(@x, @y, 2, 1, 1, color)
  end

  def is_pressed(x, y)
    Input.button_pressed(Gosu::MS_LEFT) && point_intersects(x, y)
  end
end