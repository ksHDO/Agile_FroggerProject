class Collidable
  def initialize(x, y, image)
    @aabb = AABB.new(x, y, image)
  end

  def intersects(collidable)
    if @aabb.intersects(collidable.get_aabb)

    end
  end

  private
  def get_aabb
    @aabb
  end
end