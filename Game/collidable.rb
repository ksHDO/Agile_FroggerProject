require '../Game/aabb'

module Collidable

  attr_accessor :aabb
  attr_accessor :width, :height

  def init_collision(x, y, image)
    @aabb = AABB.new(x, y, image)
    @width = image.width
    @height = image.height
  end

  def intersects(collidable)
    @aabb.intersects(collidable.aabb)
  end

  def point_intersects(x, y)
    @aabb.point_intersects(x, y)
  end

end