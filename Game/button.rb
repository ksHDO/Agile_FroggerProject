require '../Game/collidable'

class Button
  include Collidable

  def initialize(x,y,image)
    @x = x
    @y = y
    @image = image
    init_collision(x,y,image)
  end

  def draw()
    @image.draw(@x, @y, 1)
  end

  def is_pressed(x, y)
    Input.button_pressed(Gosu::MS_LEFT) && point_intersects(x, y)
  end
end