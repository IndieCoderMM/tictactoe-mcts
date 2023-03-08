class Node 
    attr_reader :sum 
    attr_reader :visits 
    attr_reader :state 
    attr_reader :action_taken
    attr_reader :children

    def initialize(game, args, state, parent=nil, action_taken=nil)
        @game = game 
        @args = args 
        @state = state 
        @parent = parent
        @action_taken = action_taken

        @children = []
        @expandable_moves = game.get_legal_moves(state)
        @visits = 0
        @sum = 0
    end

    def is_fully_expanded
        !@expandable_moves.include?(true) && @children.length > 0
    end

    def get_ucb(child)
        q_value = 1 - ((child.sum.to_f / child.visits) + 1) / 2
        # * UCB Formula
        q_value + @args[:C] * Math.sqrt(Math.log(@visits)/child.visits)
    end

    def select
        best_child = nil 
        best_ucb = -Float::INFINITY
        puts(best_ucb)
        @children.each do |child|
            ucb = get_ucb(child)
            if ucb > best_ucb
                best_ucb = ucb
                best_child = child 
            end
        end
        return best_child
    end 

    def choose_random_move(moves)
        # puts("Choices: ",moves.map.with_index {|v,i| i if v}.compact.to_s )
        moves.map.with_index {|v,i| i if v}.compact.sample()
    end

    def expand 
        action = choose_random_move(@expandable_moves)
        # puts("Action:", action)
        child_state = @state.map {|r| r.map(&:clone)}
        child_state = @game.get_next_state(child_state, action, 1)
        child_state = @game.change_perspective(child_state, -1)        

        child = Node.new(@game, @args, child_state, self, action)
        @children.push(child)
        return child 
    end 

    def simulate
        value, is_gameover = @game.check_gameover(@state, @action_taken)
        winner = @game.get_opponent(value)
        return winner if is_gameover

        rollout_state = @state.map {|r| r.map(&:clone)}
        # puts("Rollout: ", rollout_state.to_s)
        rollout_player = 1
        while true 
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
        @sum += value 
        @visits += 1

        value = @game.get_opponent(value)
        @parent.backpropagate(value) if @parent
    end 
end

