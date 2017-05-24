class AABB
  def initialize(x, y, image)
    @min_x = x - (image.width / 2)
    @max_x = x + (image.width / 2)
    @min_y = y - (image.height / 2)
    @max_y = y + (image.height / 2)
  end

  def update(dx, dy)
    @min_x += dx
    @max_x += dx
    @min_y += dy
    @max_y += dy
  end

  def intersects(bounding_box)
    _result = (bounding_box.get_max_x > @min_x and bounding_box.get_min_x < get_max_x and bounding_box.get_max_y > @min_y and bounding_box.get_min_y < get_max_y)
  end

  def get_min_x
    @min_x
  end

  def get_max_x
    @max_x
  end

  def get_min_y
    @min_y
  end

  def get_max_y
    @max_y
  end
end