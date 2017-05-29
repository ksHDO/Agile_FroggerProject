require 'gosu'
require '../Game/input'
require '../Game/collidable'

class Player
  def draw
    @image.draw_rot(@x + (@image.width / 2), @y + (@image.height / 2), 1, @angle)
  end
end

class FrogPlayer < Player
  include Collidable

  attr_accessor :x, :y
  attr_accessor :angle, :image

  def initialize
    @image = Gosu::Image.new("../assets/images/gorf.png")
    @angle = 0.0
    init_collision(0, 0, @image)
    respawn
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

  def on_collision(collider)
    respawn
  end

  def respawn()
    @x = rand((@image.width / 2)...$window_x)
    @y = $window_y - @image.height - 1
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

  attr_accessor :x, :y

  def initialize(x, y, speed)
    @image = Gosu::Image.new('../assets/images/top2.0.png')
    @x = x
    @y = y
    @speed = speed
    @angle = -90
    init_collision(x, y, @image)
  end

  def update
    move
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  def on_collision(collider)
    #maybe do stuff?
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

  def setRotation(angle)
    @angle = angle
  end
end
