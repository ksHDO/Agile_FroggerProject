require '../Game/aabb'
class Clickable

  def initialize(x, y, image)
    @aabb = AABB.new(x, y, image)
  end

  def intersects(x, y)
    @aabb.point_intersects(x, y)
  end

  def on_click

  end
end