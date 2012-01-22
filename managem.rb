#!/usr/bin/env ruby

require 'fileutils'

require './lib/env'
require './lib/conf'
require './lib/manager'
require './lib/game'
require './lib/launcher'
require './lib/country'
require './lib/team'

def ask label
	print "#{label} ? "
	gets
	return $_.chomp
end

Env.install

puts "Welcome to Managem #{Managem::Version}"

# debut du jeu

game = Launcher.new.startGame

# fin du jeu

gameName = ask "Saving game as..."
game.setName gameName
game.save


