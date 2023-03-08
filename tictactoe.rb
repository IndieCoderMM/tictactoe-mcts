class TicTacToe
  def initialize
    @rows = 3
    @cols = 3
    @action_size = @rows * @cols
  end

  def get_initial_state 
    Array.new(@rows){ Array.new(@cols) {0}}
  end

  def get_next_state(state, action, player)
    row, col = get_row_col(action)
    state[row][col] = player 
    return state  
  end 

  def get_legal_moves(state)
    state.flatten.map {|s| s === 0}
  end 

  def get_diagonals(state, indices)
    state.flatten.reject.with_index { !indices.include? _2}
  end

  def get_row_col(action)
    return action / @cols, action % @cols
  end

  def check_win(state, action) 
    return false if action.nil?
    row, col = get_row_col(action)
    player = state[row][col]
    is_row_connected = state[row].sum === player * @rows 
    is_col_connected = state.transpose[col].sum === player * @cols
    # TODO Check diagonals 
    is_ldiag_connected = get_diagonals(state, [0, 4, 8]).sum === player * @cols 
    is_rdiag_connected = get_diagonals(state, [2, 4, 6]).sum === player * @cols
    return is_row_connected || is_col_connected || is_ldiag_connected || is_rdiag_connected
  end 

  def get_winner(state, action)
    row, col = get_row_col(action)
    return state[row][col]
  end

  def check_gameover(state, action)
    # TODO Return winner and terminate 
    # if there's win condition
    # get value from action 
    if check_win(state, action)
      return get_winner(state, action), true
    end
    # * Draw if no legal move
    unless get_legal_moves(state).any?
      return 0, true
    end
    return 0, false
  end

  def get_opponent(player) = -player

  def change_perspective(state, player)
    state.map {|i| i * player}
  end

  def print_board(state, title, p1, p2)
    board_width = 9 * @cols
    puts 
    state.each_with_index do |row, r|
      if r === 0
        puts title.upcase.center(board_width)
        puts "=" * (board_width)
      end
      row.each_with_index do |val, c|
          print " | "
          if val === 1
            print p1.center(4)
          elsif val === -1
            print p2.center(4)
          else 
            print "#{c + @cols * r + 1}".center(5)
          end
          print " |" if c === @cols - 1
      end
      puts 
      print r === @rows - 1 ? "=" * board_width : "-" * board_width
      puts 
    end
  end
end
