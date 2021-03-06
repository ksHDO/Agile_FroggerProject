require 'rubygems'
require 'gosu'
require 'socket'
require 'securerandom'
require '../Game/player'
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

    @gameState = StateStack.new
    @gameState.push StateMenu.new(@gameState)
  end

  def update
    dt = get_dt
    Input.update_mouse self.mouse_x, self.mouse_y
    @gameState.update dt
    Input.update
  end

  def get_dt
    if @lastMilliseconds == nil
      @lastMilliseconds = 0
    end
    milliseconds = Gosu::milliseconds
    dt = milliseconds - @lastMilliseconds
    @lastMilliseconds = milliseconds
    return dt / 1000.0
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