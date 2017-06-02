require 'gosu'
require '../Game/input'
require '../Game/collidable'

class Player
  def draw
    if @angle == 0.0
      @imageForward.draw(@x + (@imageForward.width / 2), @y + (@imageForward.height / 2), 1)
    elsif @angle == 180
      @imageBack.draw(@x + (@imageBack.width / 2), @y + (@imageBack.height / 2), 1)
    elsif @angle == 270
      @imageLeft.draw(@x + (@imageLeft.width / 2), @y + (@imageLeft.height / 2), 1)
    elsif @angle == 90
      @imageRight.draw(@x + (@imageRight.width / 2), @y + (@imageRight.height / 2), 1)
    end
  end
end

class FrogPlayer < Player
  include Collidable

  attr_accessor :x, :y
  attr_accessor :angle, :imageForward

  def initialize
    @imageForward = Gosu::Image.new("../assets/images/frog3.png")
    @imageBack = Gosu::Image.new("../assets/images/frog1.png")
    @imageRight = Gosu::Image.new("../assets/images/frog2.png")
    @imageLeft = Gosu::Image.new("../assets/images/frog4.png")
    @angle = 0.0
    init_collision(0, 0, @imageForward)
    respawn
  end

  def update(isAi, isMultiplayer)
    if isAi and not isMultiplayer
      choice = [method(:turn_up), method(:turn_up), method(:turn_up), method(:turn_down), method(:turn_left), method(:turn_right)].sample
      if rand(20) == 4
        choice.call
        move
      end
    else
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

  end

  def on_collision(collider)
    respawn
  end

  def respawn()
    @x = rand((@imageForward.width / 2)...$window_x)
    @y = $window_y - @imageForward.height - 1
    @aabb.set_position(@x, @y)
    @angle = 0
  end

  def move
    _dx = Gosu.offset_x(@angle, @width)
    _dy = Gosu.offset_y(@angle, @height)

    if @x + _dx > 0 && @x +_dx + @width < $window_x && @y + _dy > 0 && @y +_dy + @height < $window_y
      @x += _dx
      @y += _dy
      @aabb.update(_dx, _dy)
    end
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

end

class VehiclePlayer < Player
  attr_accessor :button, :cur_vehicles

  def initialize(button)
    @button = button
    @cur_vehicles = []
  end

  def update
    @cur_vehicles.each do |car|
      car.update
      if car.x + car.width < 0
        car.is_dead = true
        @cur_vehicles.delete(car)
      end
    end
  end

  def draw
    @cur_vehicles.each do |car|
      car.draw
    end
  end
end

class Vehicle
  include Collidable

  attr_accessor :x, :y, :angle

  def initialize(x, y, speed)
    @imageForward = Gosu::Image.new('../assets/images/top2.0.png')
    @x = x
    @y = y
    @speed = speed
    @angle = -90
    init_collision(x, y, @imageForward)
  end

  def update
    move
  end

  def draw
    @imageForward.draw(self.x, self.y, 1)
  end

  def on_collision(collider)
    #maybe do stuff?
  end

  def x
    @x
  end

  def setX(x)
    @x = x
  end
  def y
    @y
  end
  def setY(y)
    @y = y
  end

  def move
    _dx = Gosu.offset_x(@angle, @speed)
    _dy = Gosu.offset_y(@angle, @speed)
    @x += _dx
    @y += _dy

    @aabb.update(_dx, _dy)
  end

  def angle
    @angle
  end

  def set_rotation(angle)
    @angle = angle
  end
end
