require 'gosu'
require '../Game/input'
require '../Game/collidable'


class Player
  attr_accessor :x, :y

  def initialize(xx, yy)
    self.x = xx
    self.y = yy
  end

  def draw
    @image.draw_rot(self.x, self.y, 1, @angle)
  end

  def on_collision(collider)
    puts "There was a collision"
  end

  def turn_up
    @angle = 0
  end

  def turn_down
    @angle = 180
  end

  def turn_left
    @angle = 270
  end

  def turn_right
    @angle = 90
  end

  def move
    _dx = Gosu.offset_x(@angle, 48)
    _dy = Gosu.offset_y(@angle, 48)
    self.x += _dx
    self.y += _dy

      # @aabb.update(_dx, _dy)
  end
end

class FrogPlayer < Player
  attr_accessor :angle, :image

  def initialize(x, y)
    @image = Gosu::Image.new("../assets/images/gorf.png")
    @angle = 0.0
    super(x, y)
  end

  def update
    if Input.button_pressed(Gosu::KB_W) or Input.button_pressed(Gosu::Button::KbUp)
      turn_up
      move
    elsif Input.button_pressed(Gosu::KB_A) or Input.button_pressed(Gosu::Button::KbLeft)
      turn_left
      move
    elsif Input.button_pressed(Gosu::KB_S) or Input.button_pressed(Gosu::Button::KbDown)
      turn_down
      move
    elsif Input.button_pressed(Gosu::KB_D) or Input.button_pressed(Gosu::Button::KbRight)
      turn_right
      move
    end
  end

  def collides_with(car)
    if ((self.x + 48  >= car.x) && (self.x <= car.x + 128)) && ((self.y + 48 >= car.y) && (self.y <= car.y + 128))
      true
    else
      false
    end
  end
end

class VehiclePlayer < Player
  attr_accessor :button, :cur_vehicles

  def initialize(button)
    @button = button
    @cur_vehicles = []
  end

  def update
    move
  end

  def draw
    @cur_vehicles.each do |car|
      car.draw
    end
  end

  def move
    @cur_vehicles.each do |car|
      car.x -= 10
    end
  end

end

class Vehicle
  attr_accessor :x, :y

  def initialize
    self.x = 1800
    self.y = 800 * rand
    @image = Gosu::Image.new('../assets/images/car.png')
  end

  def draw
    @image.draw(self.x, self.y, 1)
  end

  def move
    @x_location += Gosu.offset_x(@angle, 5)
    @y_location += Gosu.offset_y(@angle, 5)
  end

  def x
    return x
  end

  def setX(x)
    self.x = x
  end
  def y
    return y
  end
  def setY(y)
    self.y = y
  end

  def angle
    @angle
  end

  def setRotation(angle)
    @angle = angle
  end
end
