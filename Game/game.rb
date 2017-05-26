require 'rubygems'
require 'gosu'
# require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/client'
require '../Game/packet'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 640
$window_y = 480
$isFrog = false
$serverIp = "localhost"
$serverPort = 65509

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"
    # @spritesheet = Image.load_tiles(self, SPRITESHEET, 33, 33, true)
    # @map = Map.new(self, MAPFILE)  # map representing the movable area

    @player = Player.new(($window_x)*rand, $window_y-20)

    @client = Client.new($serverIp, $serverPort)
    @frameToSendOn = 2
    @currentFrameToSend = 0

    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def update
    @player.update
    if $isFrog
      @currentFrameToSend = @currentFrameToSend + 1
      if @currentFrameToSend >= @frameToSendOn
        # @client.sendInput(@player.x, @player.y)
        p = Packet.new
        p.frog_x = @player.x
        p.frog_y = @player.y
        p.frog_angle = @player.angle
        @client.sendData p
        @currentFrameToSend = 0
      end
    else
      packet = @client.get_server
      @player.setX  packet.frog_x
      @player.setY packet.frog_y
      @player.setRotation packet.frog_angle

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
