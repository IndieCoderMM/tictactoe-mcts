class TicTacToe
    def initialize
        @rows = 3
        @cols = 3
        @action_size = @rows * @cols
    end

    def get_initial_state
        return Array.new(@rows).fill(Array.new(@cols).fill(0))
    end

    def get_next_state(state, action, player)
        row = action / @cols 
        col = action % @cols 
        state[0][col] = player 
        puts "#{state} <<< DEGUG"
        return state 
    end 

    def get_legal_moves(state)
        return state.flatten.map {|s| s === 0}
    end 

    def check_win(state, action) 
        row = action / @cols 
        col = action % @cols
        player = state[row][col]
        is_row_connected = state[row].sum === player * @rows 
        is_col_connected = state.transpose[col].sum === player * @cols
        # TODO Check diagonals 
        return is_row_connected || is_col_connected
    end 

    def check_gameover(state, action)
        # if check_win(state, action)
        #     return true
        # end
        unless get_legal_moves(state).any?
            return true
        end
        return false
    end

    def get_opponent(player)
        return -player
    end 
end

tictactoe = TicTacToe.new
player = 1
state = tictactoe.get_initial_state

while true
    state.each {|r| puts r.to_s}
    puts state.to_s
    legal_moves = tictactoe.get_legal_moves(state)
    puts "Legal moves =>", (0..8).map {|i| legal_moves[i] ? i+1:nil}.to_s
    action = gets.chomp.to_i - 1

    if action === -1
        break
    end

    unless legal_moves[action] 
        puts "Invalid move!"
        next 
    end

    state = tictactoe.get_next_state(state, action, player)
    if tictactoe.check_gameover(state, action)
        puts "Game Over"
        break
    end
    player = tictactoe.get_opponent(player)
end
