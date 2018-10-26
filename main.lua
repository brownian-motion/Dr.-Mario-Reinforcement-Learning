require "actions"
require "gamestate"
require "strategies"

emu.speedmode("nothrottle") -- turn off pause between frames

enterGame()
--playSarsaGame(1e-4, 0.9)
playQLearning(1e-4, 0.9, 'scripted')