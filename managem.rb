#!/usr/bin/env ruby
require 'fileutils'
version = '0.01'

class Manager
	def initialize
	end

	def setFirstName firstName
		@firstName = firstName
	end
	def getFirstName
		return @firstName
	end

	def setLastName lastName
		@lastName = lastName
	end
	def getLastName
		return @lastName
	end
end

class Game
	def initialize
		Dir.mkdir "./data/games/run"
	end
	def setManager manager
		@manager = manager
		f = File.new('./data/games/run/manager','w')
		f.puts @manager.getFirstName
		f.puts @manager.getLastName
		f.close
	end

	def setName name
		@name = name
	end

	def save
		FileUtils.rm_rf "./data/games/#{@name}"
		FileUtils.mv( "./data/games/run" , "./data/games/#{@name}" )
	end
end

def ask label
	print "#{label} ? "
	gets
	return $_.chomp
end

puts "Welcome to Managem #{version}"

games = Dir["data/games/*"]
if games.length > 0
	puts "Load game :"
	1.upto(games.length) { |i|
		puts "#{i}: #{games[i-1]}"
	}
	puts "n: Start new game"
	ask "Your choice"
end

	puts "Starting new Game..."
	man = Manager.new
	man.setFirstName ( ask "First Name")
	man.setLastName (ask "Last Name")
	game = Game.new
	game.setManager(man)
#end


gameName = ask "Saving game as..."
game.setName gameName
game.save


