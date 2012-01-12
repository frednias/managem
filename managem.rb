#!/usr/bin/env ruby

require 'fileutils'

require 'lib/conf'
require 'lib/manager'
require 'lib/game'
require 'lib/launcher'

class Country
	def select
		return []
	end
end

#c = Country.new
#c.select.push 'a'

#exit

def ask label
	print "#{label} ? "
	gets
	return $_.chomp
end

puts "Welcome to Managem #{Managem::Version}"

# debut du jeu

game = Launcher.new.startGame

# fin du jeu

gameName = ask "Saving game as..."
game.setName gameName
game.save


