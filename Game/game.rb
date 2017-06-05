require 'rubygems'
require 'gosu'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/client'
require '../Game/packet'
require '../Game/collision_detection'
require '../Game/button'

require_relative 'states/state_menu'

include Gosu

$isFrog = true
$serverIp = "localhost"
$serverPort = 65509
$window_x = 1600
$window_y = 900

class GameWindow < Window

  attr_accessor :view
  attr_reader :menu_font

  def initialize
    super $window_x, $window_y
    @view = :menu

    self.caption = "Reggorf"
    #
    # begin
    #   @client = Client.new($serverIp, $serverPort)
    # rescue => ex
    #   puts "Could not connect to server, running locally"
    # end

    @gameState = StateStack.new
    @gameState.push StateMenu.new(@gameState)


    @frameToSendOn = 2
    @currentFrameToSend = 0

  end

  def notify_server
    @currentFrameToSend = @currentFrameToSend + 1
    if @currentFrameToSend >= @frameToSendOn
      p = Packet.new
      p.vehicle_x = []
      p.vehicle_y = []
      p.vehicle_speed = []
      if $isFrog
        p.frog_x = @frog_player.x
        p.frog_y = @frog_player.y
        p.frog_angle = @frog_player.angle
      else
        # send vehicles
        # @vehicle_player.cur_vehicles.each do |vehicle|
        #
        #   p.vehicle_x.push(vehicle.x)
        #   p.vehicle_y.push(vehicle.y)
        #   p.vehicle_speed.push(vehicle.speed)
        # end
      end

      @client.sendData p
      @currentFrameToSend = 0
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
            puts "Exception: " + ex
            @client = nil
            return
          end
          if packet == nil
            puts "Error receiving packet."
          else
            if not $isFrog
              @frog_player.x = packet.frog_x
              @frog_player.y = packet.frog_y
              @frog_player.angle = packet.frog_angle
            else
              # Receive vehicles here
              # @vehicle_player.cur_vehicles= []
              # for i in 0..packet.vehicle_x.count - 1
              #   v = Vehicle.new(packet.vehicle_x[i], packet.vehicle_y[i], packet.vehicle_speed[i])
              #   @vehicle_player.cur_vehicles.push(v)
              # end
            end
          end
        end
      }
    end
  end

  def update
    @gameState.update

    Input.update
    Input.mouse_x = self.mouse_x
    Input.mouse_y = self.mouse_y
  end


  def draw
    @gameState.draw
  end


  def needs_cursor?
    true
  end

  def button_down(id)
    if id == Gosu::KbEscape
      if (@gameState.count > 1)
        @gameState.pop
      else
        close
      end
    else
      super
    end
  end

end
window = GameWindow.new
window.show