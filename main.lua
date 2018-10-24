require "actions"
require "gamestate"
require "strategies"

enterGame()
--playSarsaGame(1e-4, 0.9)
playQLearning(1e-4, 0.9, 'scripted')