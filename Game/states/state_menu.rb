require_relative 'game_state'
require_relative 'state_main_game'

require 'gosu'
require_relative '../button'
require_relative '../input'

class StateMenu < GameState
  def initialize(state_stack)
    @state_stack = state_stack

    @menu_font = Gosu::Font.new(50)
    @frog_button = Button.new($window_x/2-110, $window_y/2, Gosu::Image.new('../assets/images/button_frog.png', :tileable => false, :retro => true))
    @vehicle_button = Button.new($window_x/2, $window_y/2, Gosu::Image.new('../assets/images/button_vehicle.png', :tileable => false, :retro => true))
    @single_player_button = Button.new($window_x/2-200, $window_y/2+100, Gosu::Image.new('../assets/images/button_single-player.png', :tileable => false, :retro => true))
    @multi_player_button = Button.new($window_x/2, $window_y/2+100, Gosu::Image.new('../assets/images/button_multi-player.png', :tileable => false, :retro => true))
    @start_button = Button.new($window_x/2-100, $window_y/2+300, Gosu::Image.new('../assets/images/button_start.png', :tileable => false, :retro => true))

    @isFrog = true
    @isMultiplayer = false
  end

  def update(dt)
    if @frog_button.is_pressed(Input.mouse_x, Input.mouse_y)
      @isFrog = true
    elsif @vehicle_button.is_pressed(Input.mouse_x, Input.mouse_y)
      @isFrog = false
    elsif @single_player_button.is_pressed(Input.mouse_x, Input.mouse_y)
      @isMultiplayer = false
    elsif @multi_player_button.is_pressed(Input.mouse_x, Input.mouse_y)
      @isMultiplayer = true
    elsif @start_button.is_pressed(Input.mouse_x, Input.mouse_y)
      @state_stack.push StateMainGame.new(@state_stack, @isFrog, @isMultiplayer)
    end
  end

  def draw
    menu_font_text = "REGGORF"
    menu_font_x_coordinate = $window_x/2 -100
    menu_font_y_coordinate = 100
    menu_font_z_coordinate = 0
    @menu_font.draw(
        menu_font_text,
        menu_font_x_coordinate,
        menu_font_y_coordinate,
        menu_font_z_coordinate
    )
    @frog_button.draw
    @vehicle_button.draw
    @single_player_button.draw
    @multi_player_button.draw
    @start_button.draw
  end
end