require 'rubygems'
require 'gosu'
require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$window_x = 640
$window_y = 480

class EchoClient
  include Celluloid::IO

  def initialize(host, port)
    puts "*** Connecting to echo server on #{host}:#{port}"

    # This is actually creating a Celluloid::IO::TCPSocket
    @socket = TCPSocket.new(host, port)
  end

  def echo(s)
    @socket.write(s)
    @socket.readpartial(4096)
  end
end

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"
    # @spritesheet = Image.load_tiles(self, SPRITESHEET, 33, 33, true)
    # @map = Map.new(self, MAPFILE)  # map representing the movable area
    @client = EchoClient.new("127.0.0.1", 1234)
    puts @client.echo("TEST FOR ECHO")

    @player = Player.new($window_x / 2, $window_y)
    # @font = Font.new(self, 'Courier New', 20)  # for the player names
  end

  def update
    @player.update
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
