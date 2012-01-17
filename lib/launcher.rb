
class Launcher
	def initialize
		@games = Dir["data/games/*"]
	end

	def startNewGame

		puts "Starting new Game..."

		man = Manager.new
		man.setFirstName(ask "First Name")
		man.setLastName(ask "Last Name")

		game = Game.new
		game.setManager(man)
		
		puts "Choose a country :"

		listCountry = Country.query.filterByPlayable(1).find
		1.upto(listCountry.length) { |i|
			puts "#{i}: #{listCountry[i-1]}"
		}

		return game
	end

	def loadOldGame (choice)

		puts 'Get old game'

		f = File.new("#{@games[choice.to_i-1]}/manager",'r')
		firstName = f.gets.chomp
		lastName = f.gets.chomp

		man = Manager.new
		man.setFirstName firstName
		man.setLastName lastName

		game = Game.new
		game.setManager(man)

		puts "Your Name : #{firstName} #{lastName}"

		return game
	end

	def startGame
		if @games.length > 0
			puts "Load game :"
			1.upto(@games.length) { |i|
				puts "#{i}: #{@games[i-1]}"
			}
			puts "n: Start new game"
			choice = ask "Your choice"
			if choice == 'n'
				game = startNewGame
			else
				game = loadOldGame(choice)
			end
		else
			game = startNewGame
		end
		game.run
		return game
	end

end

