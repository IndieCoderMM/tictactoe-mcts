require "./tictactoe.rb"

tictactoe = TicTacToe.new
player = 1
p1_avatar = "😃"
p2_avatar = "😈"
state = tictactoe.get_initial_state

while true
  tictactoe.print_board(state, "Tictactoe Master", p1_avatar, p2_avatar)
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
    break
  end
  player = tictactoe.get_opponent(player)
end