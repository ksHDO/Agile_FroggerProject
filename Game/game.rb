require 'rubygems'
require 'gosu'
require 'socket'
require 'securerandom'
require '../Game/player'
require '../Game/client'
require '../Game/packet'
require '../Game/collision_detection'
require '../Game/button'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg-temp.png', :tileable => false, :retro => true)
# $main_menu_image = Gosu::Image.new('../assets/images/kermit.gif')
$isFrog = false
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
    @menu_font = Gosu::Font.new(50)
    self.caption = "Reggorf"

    begin
      @client = Client.new($serverIp, $serverPort)
    rescue => ex
      puts "Could not connect to server, running locally"
    end

    @frameToSendOn = 2
    @currentFrameToSend = 0

    @button1 = Button.new(75,30,Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @button2 = Button.new(275,30,Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @button3 = Button.new(475,30,Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @button4 = Button.new(675,30,Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
    @frog_player = FrogPlayer.new
    @vehicle_player = VehiclePlayer.new(@button1)
    @collision = CollisionDetection.new(Array.[](@frog_player))
    # @font = Font.new(self, 'Courier New', 20)  # for the player names

    unless $isFrog
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
    if view == :menu
      if button_down?(Gosu::KbF)
        $isFrog=true
        self.view = :game
      elsif button_down?(Gosu::KbV)
        $isFrog=false
        self.view = :game
      end
    elsif view == :game
      if @client != nil
        notify_server
      end
      # must update collision first
      @collision.update
      @frog_player.update(!$isFrog)
      @vehicle_player.update

      press_event(@button1, self.mouse_x, self.mouse_y)
      press_event(@button2, self.mouse_x, self.mouse_y)
      press_event(@button3, self.mouse_x, self.mouse_y)
      press_event(@button4, self.mouse_x, self.mouse_y)

      # must update input last
      Input.update
    end
  end

  def press_event(button, mouse_x, mouse_y)
    if button.is_pressed(mouse_x, mouse_y)
      _vehicle = Vehicle.new($window_x, rand(0...$window_y),5)
      @vehicle_player.cur_vehicles.push(_vehicle)
      @collision.add_collidable(_vehicle)
    end
  end

  def draw
    if view == :menu
      draw_menu
    elsif view == :game
      $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
      @frog_player.draw
      @button1.draw
      @button2.draw
      @button3.draw
      @button4.draw
      @vehicle_player.draw
    end
    
  end

  def draw_menu
    menu_font_text = "REGGORF Press 'f' For Frog or 'v' for Vehicle"
    menu_font_x_coordinate = $window_x/3
    menu_font_y_coordinate = 100
    menu_font_z_coordinate = 0
    menu_font.draw(
        menu_font_text,
        menu_font_x_coordinate,
        menu_font_y_coordinate,
        menu_font_z_coordinate
    )
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