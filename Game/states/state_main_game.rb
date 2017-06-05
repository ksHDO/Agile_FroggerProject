require 'gosu'

require_relative 'game_state'
require_relative '../player'
require_relative '../collision_detection'
require_relative '../button'
require_relative '../input'

class StateMainGame
  def initialize(state_stack, isFrog, isMultiplayer)
    @state_stack = state_stack
    @isFrog = isFrog
    @isMultiplayer = isMultiplayer

    @background_image = Gosu::Image.new('../assets/images/bg-temp.png', :tileable => false, :retro => true)
    @button1 = Button.new(75, 30, Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @button2 = Button.new(275, 30, Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @button3 = Button.new(475, 30, Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @button4 = Button.new(675, 30, Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
    @sfxSelect = Sample.new('../assets/sfx/select.wav')

    @frog_player = FrogPlayer.new
    @vehicle_player = VehiclePlayer.new(@button1)
    @vehicle_player_cooldown = 4.0
    @vehicle_player_cooltime = 0.0
    @canSpawnVehicle = true
    @collision = CollisionDetection.new(Array.[](@frog_player))
  end
  def update
    # if @client != nil
    #   notify_server
    # end
    # must update collision first
    @collision.update
    # @frog_player.update(false)
    @frog_player.update(!@isFrog, @isMultiplayer)
    @vehicle_player.update
    if not @isFrog
      if not @canSpawnVehicle
        @vehicle_player_cooltime -= Gosu::milliseconds() * 0.00001
        if @vehicle_player_cooltime <= 0.0
          @canSpawnVehicle = true
          @sfxSelect.play
        end
      else
        # puts Input.mouse_x.to_s + "..." + Input.mouse_y.to_s
        press_event(@button1, Input.mouse_x, Input.mouse_y, Vehicle, nil)
        press_event(@button2, Input.mouse_x, Input.mouse_y, SpecialVroom, 'add')
        press_event(@button3, Input.mouse_x, Input.mouse_y, SpecialVroom, 'multiply')
        press_event(@button4, Input.mouse_x, Input.mouse_y, SpecialVroom, 'mod')
      end
    end
    if !@isMultiplayer and @isFrog
      if rand(25) == 4
        push_car
      end
    end
  end

  def press_event(button, mouse_x, mouse_y, classtype, operation)
    if button.is_pressed(mouse_x, mouse_y)
      if @canSpawnVehicle
        if classtype == Vehicle
          _vehicle = Vehicle.new($window_x, rand(100...$window_y - 200), 5)
        elsif classtype == SpecialVroom
          _vehicle = SpecialVroom.new($window_x, rand(100...$window_y - 200), 5, operation)
        end

        @vehicle_player.cur_vehicles.push(_vehicle)
        @collision.add_collidable(_vehicle)
        @canSpawnVehicle = false
        @vehicle_player_cooltime = @vehicle_player_cooldown
      end
    end
  end

  def push_car
    classtype = [Vehicle, SpecialVroom].sample
    operation = ['add','multiply', 'mod'].sample
    if classtype == Vehicle
      _vehicle = Vehicle.new($window_x, rand(0...$window_y), 5)
    elsif classtype == SpecialVroom
      _vehicle = SpecialVroom.new($window_x, rand(0...$window_y), 5, operation)
    end

    @vehicle_player.cur_vehicles.push(_vehicle)
    @collision.add_collidable(_vehicle)
    @canSpawnVehicle = false
    @vehicle_player_cooltime = @vehicle_player_cooldown
  end

  def draw
    @background_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @frog_player.draw
    if not @isFrog
      opacity = 1 - @vehicle_player_cooltime/@vehicle_player_cooldown
      @button1.draw(opacity)
      @button2.draw(opacity)
      @button3.draw(opacity)
      @button4.draw(opacity)
    end
    @vehicle_player.draw
  end
end