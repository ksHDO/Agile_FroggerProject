require 'gosu'
require_relative 'client'
require_relative 'packet'
require_relative 'button'
require_relative 'player'
require_relative 'collision_detection'
require_relative 'menu_states'

include Gosu

class FrogGameState
  include ServerSender

  def initialize(is_singleplayer)
    initialize_sender

    @is_singleplayer = is_singleplayer
    @frog_player = FrogPlayer.new
    @collision = CollisionDetection.new(Array.[](@frog_player))
  end

  def update(state_stack)
    if @client != nil
      notify_server
    end

    # must update collision first
    @collision.update

    @frog_player.update(!@is_singleplayer)

    if @is_singleplayer && Input.button_pressed(Gosu::KbP)
      state_stack.push(PauseGameState.new)
    end
  end

  def draw
    $background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @frog_player.draw
  end

  def notify_server
    if ready_to_send
      p = Packet.new
      p.frog_x = @frog_player.x
      p.frog_y = @frog_player.y
      p.frog_angle = @frog_player.angle
      @client.sendData p
    end
  end
end

class VehicleGameState
  include ServerListener

  def initialize(is_singleplayer)
    initialize_listener
    listen_to_server

    @is_singleplayer = is_singleplayer
    @frog_player = FrogPlayer.new
    @collision = CollisionDetection.new(Array.[](@frog_player))

    @vehicle_player = VehiclePlayer.new

    @button1 = Button.new(75,30,Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @button2 = Button.new(275,30,Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @button3 = Button.new(475,30,Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @button4 = Button.new(675,30,Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
  end

  def update(state_stack)
    # must update collision first
    @collision.update
    @vehicle_player.update

    press_event(@button1, $mouse_x, $mouse_y)
    press_event(@button2, $mouse_x, $mouse_y)
    press_event(@button3, $mouse_x, $mouse_y)
    press_event(@button4, $mouse_x, $mouse_y)

    if @is_singleplayer && Input.button_pressed(Gosu::KbP)
      state_stack.push(PauseGameState.new)
    end
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

  def press_event(button, mouse_x, mouse_y)
    if button.is_pressed(mouse_x, mouse_y)
      _vehicle = Vehicle.new($window_x, rand(0...$window_y),5)
      @vehicle_player.cur_vehicles.push(_vehicle)
      @collision.add_collidable(_vehicle)
    end
  end

  def listen_to_server
    @listen_for_input = Thread.new do
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
end