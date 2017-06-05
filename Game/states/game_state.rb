class GameState
  def update(dt)
  end

  def draw
  end
end

class StateStack
  def initialize
    @stack = []
  end

  def count
    return @stack.length
  end

  def push(state)
    @stack << state
  end

  def pop
    return @stack.pop
  end

  def update(dt)
    if @stack.length > 0
      @stack[-1].update(dt)
    end
  end

  def draw
    if @stack.length > 0
      @stack[-1].draw
    end

  end
end