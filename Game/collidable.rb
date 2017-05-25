require '../Game/aabb'

class Collidable

  def initialize(x, y, image)
    @aabb = AABB.new(x, y, image)
  end

  def on_collision

  end

  def intersects(collidable)
    @aabb.intersects(collidable.get_aabb)
  end

  def get_aabb
    @aabb
  end

end