require 'rubygems'
require 'gosu'
require 'chipmunk'

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 640
$window_y = 480
module ZOrder
  Background= *0..1
end

class GameWindow < Gosu::Window
  def initialize
    super $window_x, $window_y

    self.caption = ""

  end
  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
  end
end
window = GameWindow.new
window.show
