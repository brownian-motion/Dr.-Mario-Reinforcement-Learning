require "actions"
require "gamestate"
require "strategies"

emu.speedmode("nothrottle") -- turn off pause between frames

-- playSarsaGame(1e-3, 0.95, 3)
playQLearning(1e-4, 0.9, 'scripted')