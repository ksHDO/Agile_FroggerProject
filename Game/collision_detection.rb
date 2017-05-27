require '../Game/collidable'

class CollisionDetection

  def initialize(collidables)
    @collidables = collidables
  end

  def update
    @collidables.each_with_index do |collidable, i|
      @collidables.each_with_index do |collider, j|
        if i != j and collider.intersects(collidable)
          collidable.on_collision
        end
      end
    end
  end

  def add_collidable(collidable)
    @collidables.push(collidable)
  end
end