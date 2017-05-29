require '../Game/collidable'

class CollisionDetection

  def initialize(collidables)
    @collidables = collidables
  end

  def update
    @collidables.each_with_index do |collidable, i|
      @collidables.each_with_index do |collider, j|
        if i != j && collider.intersects(collidable)
          collidable.on_collision(collider)
        end
      end
    end
  end

  def add_collidable(collidable)
    @collidables.push(collidable)
  end

  def remove_collidable(collidabe)

  end
end