require '../Game/collidable'

class CollisionDetection

  def initialize(collidables)
    @collidables = collidables
  end

  def update
    _collidables_to_remove = []
    @collidables.each_with_index do |collidable, i|
      @collidables.each_with_index do |collider, j|
        if collidable.is_dead
          @collidables.delete(collidable)
        elsif i != j && collider.intersects(collidable)
          collidable.on_collision(collider)
        end
      end
    end
  end

  def add_collidable(collidable)
    @collidables.push(collidable)
  end
end