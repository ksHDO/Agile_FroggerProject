require 'gosu'
require_relative 'button'
require_relative 'input'

include Gosu

class MainMenuState

  attr_reader :menu_font

  def initialize
    @menu_font = Gosu::Font.new(50)
  end

  def update(state_stack)
    if Input.button_pressed(Gosu::KbF)
      state_stack.pop
      state_stack.push(FrogGameState.new(true))
    elsif Input.button_pressed(Gosu::KbV)
      state_stack.pop
      state_stack.push(VehicleGameState.new(true))
    end
  end

  def draw
    # $main_menu_image.draw_as_quad(0, 0, 0xffffffff, $window_x, 0, 0xffffffff, $window_x, $window_y, 0xffffffff, 0, $window_y, 0xffffffff, 0)
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
end

class PauseGameState

  def initialize

  end

  def update(state_stack)
    if Input.button_pressed(Gosu::KbP)
      state_stack.pop
    end
  end

  def draw

  end
end