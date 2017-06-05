require 'gosu'

require_relative 'game_state'
require_relative '../player'
require_relative '../collision_detection'
require_relative '../button'
require_relative '../packet'
require_relative '../client'
require_relative '../input'

class StateMainGame
  def initialize(state_stack, isFrog, isMultiplayer)
    @state_stack = state_stack
    @isFrog = isFrog
    @isMultiplayer = isMultiplayer

    if @isMultiplayer
      begin
        @client = Client.new($serverIp, $serverPort)
      rescue => ex
        puts "Could not connect to server, running locally"
      end
      @p = Packet.new
      listen_to_server
      @createVehicle = false
      @createVehicleIsSpecial = false
      @createVehicleOperation = ''
      @createVehicleX = 0
      @createVehicleY = 0
      @createVehicleSpeed = 0
    end


    @img_background = Gosu::Image.new('../assets/images/bg-temp.png', :tileable => false, :retro => true)
    @btnVehicle1 = Button.new(75, 30, Gosu::Image.new('../assets/images/button1.png', :tileable => false, :retro => true))
    @btnVehicle2 = Button.new(275, 30, Gosu::Image.new('../assets/images/button2.png', :tileable => false, :retro => true))
    @btnVehicle3 = Button.new(475, 30, Gosu::Image.new('../assets/images/button3.png', :tileable => false, :retro => true))
    @btnVehicle4 = Button.new(675, 30, Gosu::Image.new('../assets/images/button4.png', :tileable => false, :retro => true))
    @sfxSelect = Sample.new('../assets/sfx/select.wav')

    @frog_player = FrogPlayer.new
    @vehicle_player = VehiclePlayer.new(@btnVehicle1)
    @vehicle_player_cooldown = 0.5
    @vehicle_player_cooltime = 0.0
    @canSpawnVehicle = true
    @collision = CollisionDetection.new(Array.[](@frog_player))

    @frameToSendOn = 2
    @currentFrameToSend = 0
  end


  def notify_server
    @currentFrameToSend = @currentFrameToSend + 1
    if @currentFrameToSend >= @frameToSendOn
      if @isFrog
        notify_server_frog
      else
        # send vehicles
        # @vehicle_player.cur_vehicles.each do |vehicle|
        #
        #   p.vehicle_x.push(vehicle.x)
        #   p.vehicle_y.push(vehicle.y)
        #   p.vehicle_speed.push(vehicle.speed)
        # end
      end

      @client.sendData @p
      @currentFrameToSend = 0
    end
  end

  def notify_server_frog
    @p.frog_x = @frog_player.x
    @p.frog_y = @frog_player.y
    @p.frog_angle = @frog_player.angle
  end

  def notify_server_vehicle(vehicle, is_special, operation)
    # @p.vehicle_x = []
    # @p.vehicle_y = []
    # @p.vehicle_speed = []
    # @vehicle_player.cur_vehicles.each do |vehicle|
    #   @p.vehicle_x.push(vehicle.x)
    #   @p.vehicle_y.push(vehicle.y)
    #   @p.vehicle_speed.push(vehicle.speed)
    # end
    @p.vehicle_is_special = is_special
    @p.vehicle_operation = operation
    @p.vehicle_x = vehicle.x
    @p.vehicle_y = vehicle.y
    @p.vehicle_speed = vehicle.speed

    @client.sendData @p
  end

  def listen_to_server
    @listenForInput = Thread.new do
      loop {
        if @client != nil
          packet = nil
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
            if not @isFrog
              @frog_player.x = packet.frog_x
              @frog_player.y = packet.frog_y
              @frog_player.angle = packet.frog_angle
            else

              if packet.vehicle_x != nil
                # puts 'got vehicles'
                # puts '    X:' + packet.vehicle_x.to_s
                # puts '    Y:' + packet.vehicle_y.to_s
                # puts 'Speed: ' + packet.vehicle_speed.to_s

                @createVehicleIsSpecial = packet.vehicle_is_special
                @createVehicleOperation = packet.vehicle_operation
                @createVehicleX = packet.vehicle_x
                @createVehicleY = packet.vehicle_y
                @createVehicleSpeed = packet.vehicle_speed
                @createVehicle = true

                # puts 'create a vehicle'

              end

            end
          end
        end
      }
    end
  end

  def update(dt)
    if @client != nil and @isMultiplayer and @isFrog
      notify_server
    end
    # must update collision first
    @collision.update
    # @frog_player.update(false)
    @frog_player.update(!@isFrog, @isMultiplayer)
    @vehicle_player.update(dt)
    if not @isFrog
      if not @canSpawnVehicle
        @vehicle_player_cooltime -= dt
        if @vehicle_player_cooltime <= 0.0
          @canSpawnVehicle = true
          @sfxSelect.play
        end
      else
        press_event(@btnVehicle1, Input.mouse_x, Input.mouse_y, Vehicle, nil)
        press_event(@btnVehicle2, Input.mouse_x, Input.mouse_y, SpecialVroom, 'add')
        press_event(@btnVehicle3, Input.mouse_x, Input.mouse_y, SpecialVroom, 'multiply')
        press_event(@btnVehicle4, Input.mouse_x, Input.mouse_y, SpecialVroom, 'mod')
      end
    end
    if !@isMultiplayer and @isFrog
      @vehicle_player_cooltime -= dt
      if @vehicle_player_cooltime <= 0.0 and rand(25) == 4
        push_car
      end
    end

    # test
    if @createVehicle
      if @createVehicleIsSpecial
        v = SpecialVroom.new(@createVehicleX, @createVehicleY, @createVehicleSpeed, @createVehicleOperation)
      else
        v = Vehicle.new(@createVehicleX, @createVehicleY, @createVehicleSpeed)
      end


      @vehicle_player.cur_vehicles.push(v)
      @collision.add_collidable(v)
      @canSpawnVehicle = false
      @vehicle_player_cooltime = @vehicle_player_cooldown
      @createVehicle = false
    end
  end

  def press_event(button, mouse_x, mouse_y, classtype, operation)
    if button.is_pressed(mouse_x, mouse_y)
      if @canSpawnVehicle
        spawn_car(classtype, operation)
      end
    end
  end

  def push_car
    classtype = [Vehicle, SpecialVroom].sample
    operation = ['add','multiply', 'mod'].sample
    spawn_car(classtype, operation)
  end

  def spawn_car(classtype, operation)
    if classtype == Vehicle
      _vehicle = Vehicle.new($window_x, rand(0...$window_y), 5)
    elsif classtype == SpecialVroom
      _vehicle = SpecialVroom.new($window_x, rand(0...$window_y), 5, operation)
    end
    @vehicle_player.cur_vehicles.push(_vehicle)
    @collision.add_collidable(_vehicle)
    @canSpawnVehicle = false
    @vehicle_player_cooltime = @vehicle_player_cooldown
    if !@isFrog and @isMultiplayer
      notify_server_vehicle(_vehicle, classtype == SpecialVroom, operation)
    end
  end

  def draw
    @img_background.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
    @frog_player.draw
    if not @isFrog
      opacity = 1 - @vehicle_player_cooltime/@vehicle_player_cooldown
      @btnVehicle1.draw(opacity)
      @btnVehicle2.draw(opacity)
      @btnVehicle3.draw(opacity)
      @btnVehicle4.draw(opacity)
    end
    @vehicle_player.draw
  end
end