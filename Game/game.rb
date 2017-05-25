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
    @button1 = Button.new(75,30,Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @button2 = Button.new(275,30,Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @button3 = Button.new(475,30,Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @button4 = Button.new(675,30,Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
    @player = Player.new(100, $window_y-20)
    @collision = CollisionDetection.new(Array.[](@player))
    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def update
    # must update collision first
    @collision.update

    @player.update
    if Input.button_pressed(Gosu::MS_LEFT)
      if @button1.intersects(self.mouse_x, self.mouse_y)
        @button1.on_click
      end
      if @button2.intersects(self.mouse_x, self.mouse_y)
        @button2.on_click
      end
      if @button3.intersects(self.mouse_x, self.mouse_y)
        @button3.on_click
      end
      if @button4.intersects(self.mouse_x, self.mouse_y)
        @button4.on_click
      end
    end

    # must update input last
    Input.update
  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @player.draw
    @button1.draw
    @button2.draw
    @button3.draw
    @button4.draw
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