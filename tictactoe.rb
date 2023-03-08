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
    row = action / @cols 
    col = action % @cols 
    state[row][col] = player 
    return state  
  end 

  def get_legal_moves(state)
    state.flatten.map {|s| s === 0}
  end 

  def get_diagonals(state, indices)
    state.flatten.reject.with_index { !indices.include? _2}
  end

  def check_win(state, action) 
    row = action / @cols 
    col = action % @cols
    player = state[row][col]
    is_row_connected = state[row].sum === player * @rows 
    is_col_connected = state.transpose[col].sum === player * @cols
    # TODO Check diagonals 
    is_ldiag_connected = get_diagonals(state, [0, 4, 8]).sum === player * @cols 
    is_rdiag_connected = get_diagonals(state, [2, 4, 6]).sum === player * @cols
    return is_row_connected || is_col_connected || is_ldiag_connected || is_rdiag_connected
  end 

  def check_gameover(state, action)
    if check_win(state, action)
      return true
    end
    unless get_legal_moves(state).any?
      return true
    end
    return false
  end

  def get_opponent(player) = -player

  def print_board(state, title, p1, p2)
    board_width = 9 * @cols
    puts 
    state.each_with_index do |row, r|
      if r === 0
        puts title.upcase.center(board_width)
        puts "-" * (board_width)
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
      print "-" * (board_width)
      puts 
    end
  end
end

tictactoe = TicTacToe.new
player = 1
state = tictactoe.get_initial_state

while true
  tictactoe.print_board(state, "Tictactoe Master", "😃", "😈")
  legal_moves = tictactoe.get_legal_moves(state)
  print "Enter your move => "
  action = gets.chomp.to_i - 1

  if action === -1
    break
  end

  unless legal_moves[action] 
    puts "🔴Invalid move!"
    next 
  end

  state = tictactoe.get_next_state(state, action, player)
  if tictactoe.check_gameover(state, action)
    # TODO Display game over state
    puts "Game Over"
    break
  end
  player = tictactoe.get_opponent(player)
end
