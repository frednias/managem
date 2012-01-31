#!/usr/bin/env ruby

require 'fileutils'

require './lib/env'
require './lib/conf'
require './lib/manager'
require './lib/game'
require './lib/launcher'
require './lib/country'
require './lib/team'
require './lib/match'

def ask label
	print "#{label} ? "
	gets
	resp = $_.chomp
	if resp.length == 0
		return ask label
	else
		return resp
	end
end

Env.install

puts "Welcome to Managem #{Managem::Version}"

# debut du jeu

game = Launcher.new.startGame


game.run


# fin du jeu

gameName = ask "Saving game as..."
game.setName gameName
game.save


