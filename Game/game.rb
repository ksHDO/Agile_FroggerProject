require 'rubygems'
require 'gosu'
require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/collision_detection'
require '../Game/button'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 1600
$window_y = 900

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"
    @button = Button.new(300,300,Gosu::Image.new('../assets/images/button.jpg', :tileable => false, :retro => true))
    @player = Player.new(100, $window_y-20)
    @collision = CollisionDetection.new(Array.[](@player))
    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def update
    # must update collision first
    @collision.update

    @player.update
    if Input.button_pressed(Gosu::MS_LEFT)
      if @button.intersects(self.mouse_x, self.mouse_y)
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

  def needs_cursor?
    true
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
