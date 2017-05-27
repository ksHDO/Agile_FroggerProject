require 'gosu'

class Input
  @pressed_last_frame = Hash.new(false)

  def self.update
    @pressed_last_frame.each do |k, v|
      @pressed_last_frame[k] = button_down(k)
    end
  end

  def self.button_down(button)
    register_button(button)
    _down = Gosu.button_down? button
  end

  def self.button_pressed(button)
    register_button(button)
    _pressed = false
    if button_down(button)
      unless @pressed_last_frame[button]
        _pressed = true
      end
    end
    return _pressed
  end

  def self.button_released(button)
    register_button(button)
    _released = false
    if @pressed_last_frame[button]
      unless button_down(button)
        _released = true
      end
    end
  end

  private
  def self.register_button(button)
    unless @pressed_last_frame.has_key?(button)
      @pressed_last_frame[button] = false
    end
  end
end