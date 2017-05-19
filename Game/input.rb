require 'gosu'

class Input
  @pressed_last_frame = Hash.new(false)

  def self.button_pressed(button)
    pressed = false
    if button_down(button)
      if !@pressed_last_frame[button]
        pressed = true
      end
    end
    return pressed
  end

  def self.button_down(button)
    down = Gosu.button_down? button
  end
end