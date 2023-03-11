class Node
  attr_reader :value_sum, :visits, :state, :action_taken, :children

  # Represents each node of game tree
  # game - tictactoe class
  # args - mcts parameters
  # state - current board state
  # parent - node from which derived
  # action_taken - action taken to reach this node
  def initialize(game, args, state, parent = nil, action_taken = nil)
    @game = game
    @args = args
    @state = state
    @parent = parent
    @action_taken = action_taken

    @children = []
    @expandable_moves = game.get_legal_moves(state)
    @visits = 0
    @value_sum = 0
  end

  # Fully expanded when all legal moves have been played
  # And have child nodes
  def is_fully_expanded
    @children.length.positive? && !@expandable_moves.include?(true)
  end

  # Calculates UCB score
  def get_ucb(child)
    q_value = 1 - (((child.value_sum.to_f / child.visits) + 1) / 2)
    # * UCB Formula
    q_value + (@args[:C] * Math.sqrt(Math.log(@visits) / child.visits.to_f))
  end

  # Selects child with highest UCB
  def select
    best_child = nil
    best_ucb = -Float::INFINITY

    @children.each do |child|
      ucb = get_ucb(child)

      if ucb > best_ucb
        best_ucb = ucb
        best_child = child
      end
    end
    best_child
  end

  def choose_random_move(moves)
    moves.map.with_index { |v, i| i if v }.compact.sample
  end

  # Adds new child from an action
  def expand
    action = choose_random_move(@expandable_moves)
    @expandable_moves[action] = false

    child_state = @game.clone_state(@state)
    child_state = @game.get_next_state(child_state, action, 1)

    # State is opposite since every node considers itself as p1
    child_state = @game.change_perspective(child_state, -1)

    child = Node.new(@game, @args, child_state, self, action)
    @children.push(child)
    child
  end

  # Simulates until gameover
  def simulate
    value, is_gameover = @game.check_gameover(@state, @action_taken)
    return @game.get_opponent(value) if is_gameover

    rollout_state = @state.map { |r| r.map(&:clone) }
    rollout_player = 1
    loop do
      moves = @game.get_legal_moves(rollout_state)
      action = choose_random_move(moves)
      rollout_state = @game.get_next_state(rollout_state, action, rollout_player)
      value, is_gameover = @game.check_gameover(rollout_state, action)
      if is_gameover
        return rollout_player === -1 ? @game.get_opponent(value) : value
      end

      rollout_player = @game.get_opponent(rollout_player)
    end
  end

  def backpropagate(value)
    @value_sum += value
    @visits += 1

    value = @game.get_opponent(value)
    @parent&.backpropagate(value)
  end
end
