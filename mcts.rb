require './node'

class MCTS
  def initialize(game, args)
    @game = game
    @args = args
  end

  def search(state)
    root = Node.new(@game, @args, state)

    # ? is this looping correct
    @args[:num_searches].times do
      node = root
      # ! this while loop never reached
      # TODO: Check fully_expanded method
      while node.is_fully_expanded
        node = node.select
        # Selecting the next node to expand
        # if node has no legal moves and have children select next
        # ! Selection never begin
        puts('node selected!')
      end
      
      value, is_gameover = @game.check_gameover(node.state, node.action_taken)
      value = @game.get_opponent(value)

      unless is_gameover
        node = node.expand
        puts "Expanded: #{node}"
        value = node.simulate
      end

      node.backpropagate(value)
    end

    action_probs = Array.new(@game.action_size).fill(0)

    root.children.each do |child|
      puts "Visits #{child.visits}"
      action_probs[child.action_taken] = child.visits
    end
    puts "Probs: #{action_probs.to_s}"
    sum = action_probs.sum
    (0...action_probs.length).each do |i|
      action_probs[i] = action_probs[i].to_f / sum
    end

    action_probs
  end
end
