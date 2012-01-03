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

def startNewGame

	puts "Starting new Game..."

	man = Manager.new
	man.setFirstName ( ask "First Name")
	man.setLastName (ask "Last Name")

	game = Game.new
	game.setManager(man)
	
	puts "Choose a country :"

	countries = Country.select

	return game
end

games = Dir["data/games/*"]
if games.length > 0
	puts "Load game :"
	1.upto(games.length) { |i|
		puts "#{i}: #{games[i-1]}"
	}
	puts "n: Start new game"
	choice = ask "Your choice"
	if choice == 'n'
		game = startNewGame
	else
		puts 'Get old game'
		f = File.new("#{games[choice.to_i-1]}/manager",'r')
		firstName = f.gets.chomp
		lastName = f.gets.chomp
		man = Manager.new
		man.setFirstName firstName
		man.setLastName lastName
		game = Game.new
		game.setManager(man)
		puts "Your Name : #{firstName} #{lastName}"
	end
else
	game = startNewGame
end

# debut du jeu


# fin du jeu

gameName = ask "Saving game as..."
game.setName gameName
game.save


