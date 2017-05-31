class AABB
  attr_accessor :min_x, :max_x
  attr_accessor :min_y, :max_y

  def initialize(x, y, image)
    @image = image
    @min_x = x
    @max_x = x + (image.width)
    @min_y = y
    @max_y = y + (image.height)
  end

  def update(dx, dy)
    @min_x += dx
    @max_x += dx
    @min_y += dy
    @max_y += dy
  end

  def set_position(x, y)
    @min_x = x
    @max_x = x + (@image.width)
    @min_y = y
    @max_y = y + (@image.height)
  end

  def intersects(bounding_box)
    if bounding_box.max_x < @min_x or bounding_box.min_x > max_x
      return false
    end

    if bounding_box.max_y < @min_y or bounding_box.min_y > max_y
      return false
    end

    return true
  end

  def point_intersects(x, y)
    _result = (x > @min_x and x < @max_x and y > @min_y and y < @max_y)
  end
end