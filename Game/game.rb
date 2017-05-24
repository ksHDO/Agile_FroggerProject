require 'rubygems'
require 'gosu'
require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/button'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 1600
$window_y = 900

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"
    # @spritesheet = Image.load_tiles(self, SPRITESHEET, 33, 33, true)
    # @map = Map.new(self, MAPFILE)  # map representing the movable area
    @button = Button.new(300,300,Gosu::Image.new('../assets/images/button.jpg', :tileable => false, :retro => true))
    @player = Player.new(($window_x)*rand, $window_y-20)
    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def needs_cursor?
    true
  end
  def update
    @player.update
    if(Input.button_pressed(Gosu::MS_LEFT))
      if(@button.intersects(self.mouse_x, self.mouse_y))
        @button.on_click
      end
    end
    # must update input last
    Input.update
  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @player.draw
    @button.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      super
    end
  end
end
window = GameWindow.new
window.show
