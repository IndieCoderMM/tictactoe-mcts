# Tictactoe - MCTS 

This Tictactoe engine uses Monte Carlo Tree Search algorithm to find the best move. The algorithm builds a game tree and simulates many random games to evaluate the possible outcomes.


## Screenshot

![App Screenshot](https://via.placeholder.com/468x300?text=Demo+Program+Usage)


## Features

- Easily integrateable `Tictactoe` class
- MCTS algorithm implementation
- Modes: Human vs Computer, Computer vs Computer
- Simple command-line interface

## Algorithm

MCTS uses random simulations and tree search to explore the search space. The algorithm involves the following steps:

#### 1. Selection
Selection starts at the root and selects child nodes untill it reaches a leaf node or a node that has not been fully expanded. UCB score `reward + exploration bonus` is used to find the best node to expand. Common formula for *exploration bonus* is `C * sqrt(log(total_visits_to_parent)/visits_to_child)` where C is parameter to controls the amount of exploration.

#### 2. Expansion
When a node does not have a child node for every possible move, a new node is added to the selected node for the next move.

#### 3. Simulation
The algorithm plays the game from current node by making random moves until gameover. The result is then used to compute a reward (1 for win, -1 for loss, 0 for draw).

#### 4. Backpropagation
After a simulation, the algorithm updates the visit count and value of  each node. Visit count is increased by 1 and the value sum is updated based on the outcome of simulation. This process continues until it reaches the root.

## Run Locally

To run the TicTacToe engine locally, you will need to have Ruby installed on your system. 

Once you have Ruby installed, follow these steps:

1. Clone this repository to your local machine
2. Navigate to the project directory in your terminal
3. Run `ruby main.rb` to start the game

*The game will start in human vs computer mode by default. You can switch to computer vs computer mode by passing the `--computer` flag when starting the game.*


## Acknowledgements

- [Monte Carlo Tree Search Explained](https://int8.io/monte-carlo-tree-search-beginners-guide/)

## License
This project is [MIT](./LICENSE) licensed.


