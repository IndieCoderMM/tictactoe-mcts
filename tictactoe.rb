class TicTacToe
  attr_reader :action_size

  def initialize(size=3)
    @rows = size 
    @cols = size 
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

  def is_diag_connected(state, player)
    left_diag = []
    right_diag = []
    i = 0
    j = @cols - 1
    (@cols).times do 
      left_diag.push(i)
      right_diag.push(j)
      i += @cols + 1
      j += @cols - 1
    end 
    is_rdiag_connected = get_diagonals(state, right_diag).sum === player * @cols
    is_ldiag_connected = get_diagonals(state, left_diag).sum === player * @cols 
    return is_ldiag_connected || is_rdiag_connected
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
    return is_row_connected || is_col_connected || is_diag_connected(state, player)
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
      return 1, true
    end
    # * Draw if no legal move
    unless get_legal_moves(state).any?
      return 0, true
    end
    return 0, false
  end

  def get_opponent(player) 
    -player
  end 

  def clone_state(state)
    state.map { |r| r.map(&:clone) }
  end

  def change_perspective(state, player)
    state_ = state.map {|r| r.map(&:clone)}
    state_.each_with_index do |row, r|
      state_[r] = row.map {|i| i * player}
    end
  end

  def print_board(state, p1, p2, p1_score, p2_score, match_no)
    board_width = 9 * @cols
    title = "#{p1} : #{p1_score} | [#{match_no}] |  #{p2_score} : #{p2} "
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
