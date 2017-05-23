require 'rubygems'
require 'gosu'
# require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/client'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 640
$window_y = 480
$isFrog = true
$serverIp = "10.10.26.10"
$serverPort = 65509

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"
    # @spritesheet = Image.load_tiles(self, SPRITESHEET, 33, 33, true)
    # @map = Map.new(self, MAPFILE)  # map representing the movable area

    @player = Player.new(($window_x)*rand, $window_y-20)

    @client = Client.new($serverIp, $serverPort)

    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def update
    @player.update
    if $isFrog
      @client.sendInput(@player.x, @player.y)
    else
      strY = @client.get_server
      strX = @client.get_server
      @player.setX strX.to_f
      @player.setY strY.to_f
    end

  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @player.draw
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
