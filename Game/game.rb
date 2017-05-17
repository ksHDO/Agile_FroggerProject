require 'rubygems'
require 'gosu'

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 640
$window_y = 480

class GameWindow < Gosu::Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"

  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
