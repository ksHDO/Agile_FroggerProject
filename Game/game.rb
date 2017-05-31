require 'rubygems'
require 'gosu'
require '../Game/game_states'

include Gosu

$background_image = Gosu::Image.new('../assets/images/bg-temp.png', :tileable => false, :retro => true)
# $main_menu_image = Gosu::Image.new('../assets/images/kermit.gif')
$serverIp = "localhost"
$serverPort = 65509
$window_x = 1600
$window_y = 900
$mouse_x = 0
$mouse_y = 0

class GameWindow < Window

  def initialize
    super $window_x, $window_y
    self.caption = "Reggorf"

    @state_stack = Array.new
    @state_stack.push(MainMenuState.new)
  end

  def update
    $mouse_x = self.mouse_x
    $mouse_y = self.mouse_y

    @state_stack.last.update(@state_stack)

    # must update input last
    Input.update
  end

  def draw
    @state_stack.last.draw
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