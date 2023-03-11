require './node'

class MCTS
  def initialize(game, args)
    @game = game
    @args = args
  end

  # Peforms tree search
  # state - 2d array of current board position
  # e.g: [[1,0,1], [0,-1,-1], [1,0,0]]
  def search(state)
    root = Node.new(@game, @args, state)

    # Loops controlled by num_searches
    @args[:num_searches].times do
      node = root

      # Selecting next node to expand
      node = node.select while node.is_fully_expanded

      value, is_gameover = @game.check_gameover(node.state, node.action_taken)
      # Convert value for opponnet
      value = @game.get_opponent(value)

      unless is_gameover
        node = node.expand
        value = node.simulate
      end

      node.backpropagate(value)
    end

    action_probs = Array.new(@game.action_size).fill(0)

    root.children.each do |child|
      action_probs[child.action_taken] = child.visits
    end

    # Probs distribution of all actions
    action_probs.map { |p| p.to_f / action_probs.sum }
  end
end
