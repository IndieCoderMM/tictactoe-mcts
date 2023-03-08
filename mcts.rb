require "./node.rb"

class MCTS
    
    def initialize(game, args)
        @game = game
        @args = args 
    end 

    def search(state)
        root = Node.new(@game, @args, state)

        (0...@args[num_searches]).each do
            node = root 
            while node.is_fully_expanded
                node = node.select 

            value, is_gameover = @game.check_gameover(node.state, node.action_taken)
            winner = @game.get_opponent(value)

            unless is_gameover
                node = node.expand 
                value = node.simulate
            end
            node.backpropagate(value)
        end
        action_probs = Array.new(@game.action_size).fill(0)
        @children.each do |child|
            action_probs[child.action_taken] = child.visits 
        end
        action_probs /= action_probs.sum 
        return action_probs
    end

