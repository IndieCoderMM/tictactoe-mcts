require 'optparse'
require './tictactoe'
require './mcts'

options = {}

parser = OptionParser.new do |parser|
  parser.on("-m", "--mode MODE", "Choose mode (vsai, computer) Def:vsai")
  parser.on("-l", "--level AI_LEVEL", "Choose AI level (1..10) Def:10")
  parser.on("-z", "--size BOARD_SIZE", "Change board size (>=3) Def:3")

  parser.on("-h", "--help", "Prints this help") do
    puts parser 
    exit 
  end
end

parser.parse!(into: options)

P1 = '😃'
P2 = '😈'
p1_score = 0
p2_score = 0
match_no = 1
mode = options[:mode] || 'vsai'
level = options[:level]&.to_i || 10
size = options[:size]&.to_i || 3
level = [1, level, 10].sort[1]
size = [3, size, 6].sort[1]


game = TicTacToe.new(size)
state = game.get_initial_state
player = 1

args = { C: 1.41, num_searches: level * 100 }
mcts = MCTS.new(game, args)

game.print_board(state, P1, P2, p1_score, p2_score, match_no)

loop do
  if player === 1 && mode === "vsai"
    legal_moves = game.get_legal_moves(state)
    puts 'Moves: (1..9); Q: Exit;'
    print 'Enter your move => '
    action = $stdin.gets.chomp.to_i - 1
    break if action === -1
    
    unless legal_moves[action]
      puts '🔴Invalid move!'
      next
    end
  else
    neutral_state = game.change_perspective(state, player)
    mcts_probs = mcts.search(neutral_state)
    action = mcts_probs.find_index(mcts_probs.max)
    sleep(0.1) if mode === "computer"
  end
  
  state = game.get_next_state(state, action, player)
  value, is_gameover = game.check_gameover(state, action)
  system('clear')
  if is_gameover
    match_no += 1
    if player == 1
      p1_score += value
    else 
      p2_score += value
    end
    puts "ENGINE_LEVEL[#{level}] | MODE[#{mode === "vsai" ? "Vs AI" : "Simulation"}]"
    game.print_board(state, P1, P2, p1_score, p2_score, match_no)
    if mode === "vsai"
      if value === 0 
        puts "Draw! 🤝"
      else
        puts player === 1 ? "You win! 🎉" : "You lose! 😜"
      end
    sleep(0.3)
    end
    sleep(0.3)
    system('clear')
    state = game.get_initial_state
  end
  puts "ENGINE_LEVEL[#{level}] | MODE[#{mode === "vsai" ? "Vs AI" : "Simulation"}]"
  game.print_board(state, P1, P2, p1_score, p2_score, match_no)
  player = game.get_opponent(player)
end
