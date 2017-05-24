require '../Game/clickable'
class Button < Clickable
  def initialize(x,y,image)
    super(x,y,image)
    @x = x
    @y = y
    @image = image
  end

  def on_click()
    puts 'Hello'
  end

  def draw()
    @image.draw_rot(@x,@y, 1, 0)
  end
end