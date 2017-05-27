require 'rubygems'
require 'gosu'
# require 'celluloid/io'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/client'
require '../Game/packet'
require '../Game/collision_detection'
require '../Game/button'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg.jpg', :tileable => false, :retro => true)
$isFrog = true
$serverIp = "localhost"
$serverPort = 65509
$window_x = 1600
$window_y = 900

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"

    begin
      @client = Client.new($serverIp, $serverPort)
    rescue => ex
      puts "Could not connect to server, running locally"
    end


    @player = Player.new(($window_x)*rand, $window_y-20)
    @frameToSendOn = 2
    @currentFrameToSend = 0

    @button1 = Button.new(75,30,Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @button2 = Button.new(275,30,Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @button3 = Button.new(475,30,Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @button4 = Button.new(675,30,Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
    @frog_player = FrogPlayer.new($window_x*rand, $window_y-20)
    @vehicle_player = VehiclePlayer.new(@button1)
    @collision = CollisionDetection.new(Array.[](@frog_player))
    # @font = Font.new(self, 'Courier New', 20)  # for the player names

    if not $isFrog
      listen_to_server
    end
  end

  def notify_server
    if $isFrog
      @currentFrameToSend = @currentFrameToSend + 1
      if @currentFrameToSend >= @frameToSendOn
        p = Packet.new
        p.frog_x = @frog_player.x
        p.frog_y = @frog_player.y
        p.frog_angle = @frog_player.angle
        @client.sendData p
        @currentFrameToSend = 0
      end
    end
  end

  def listen_to_server()
    @listenForInput = Thread.new do
      loop {
        if @client != nil
          begin
            packet = @client.get_server
          rescue => ex
            puts "Lost connection to server, running locally"
            @client = nil
            return
          end
          @frog_player.x = packet.frog_x
          @frog_player.y = packet.frog_y
          @frog_player.angle = packet.frog_angle
        end
      }
    end
  end

  def update
    if @client != nil
      notify_server
    end

    # must update collision first
    @collision.update

    @frog_player.update
    @vehicle_player.update

    @vehicle_player.cur_vehicles.each do |car|
      if car.x < 0
        @vehicle_player.cur_vehicles.delete(car)
      end
      if @frog_player.collides_with(car)
        @frog_player = FrogPlayer.new($window_x*rand, $window_y-20)
        @vehicle_player.cur_vehicles.delete(car)
      end
    end
    if Input.button_pressed(Gosu::MS_LEFT)
      if @button1.intersects(self.mouse_x, self.mouse_y)
        @vehicle_player.cur_vehicles.push(Vehicle.new)
      end
      if @button2.intersects(self.mouse_x, self.mouse_y)
        @vehicle_player.cur_vehicles.push(Vehicle.new)
      end
      if @button3.intersects(self.mouse_x, self.mouse_y)
        @vehicle_player.cur_vehicles.push(Vehicle.new)
      end
      if @button4.intersects(self.mouse_x, self.mouse_y)
        @vehicle_player.cur_vehicles.push(Vehicle.new)
      end
    end
    # must update input last
    Input.update
  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @frog_player.draw
    @button1.draw
    @button2.draw
    @button3.draw
    @button4.draw
    @vehicle_player.draw
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