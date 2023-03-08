require "./tictactoe.rb"
require "./mcts.rb"

tictactoe = TicTacToe.new
player = 1
p1_avatar = "😃"
p2_avatar = "😈"
state = tictactoe.get_initial_state

args = {C: 1.41, num_searches: 1000}

mcts = MCTS.new(tictactoe, args)

while true
  tictactoe.print_board(state, "Tictactoe Master", p1_avatar, p2_avatar)

  if player === 1
    legal_moves = tictactoe.get_legal_moves(state)
    puts "Moves: (1..9); Q: Exit;"
    print "Enter your move => "
    action = gets.chomp.to_i - 1

    if action === -1
      # Terminate on any char
      break
    end

    unless legal_moves[action] 
      puts "🔴Invalid move!"
      next 
    end
  else 
    neutral_state = tictactoe.change_perspective(state, player)
    mcts_probs = mcts.search(neutral_state)
    puts("Probabilties: ", mcts_probs.to_s)
    action = mcts_probs.find_index(mcts_probs.max)
  end

  state = tictactoe.get_next_state(state, action, player)
  winner, is_gameover = tictactoe.check_gameover(state, action)
  if is_gameover
    # TODO Display game over state
    case winner 
    when 1
      title = p1_avatar + " Wins! 🎉"
    when -1
      title = p2_avatar + " Wins! 🎉"
    else 
      title = "🤝 Draw!"
    end
    tictactoe.print_board(state, title, p1_avatar, p2_avatar)
    state = tictactoe.get_initial_state
  end
  player = tictactoe.get_opponent(player)
end