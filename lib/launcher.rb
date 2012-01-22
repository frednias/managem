
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

		listCountry = CountryQuery.new.filterByPlayable(1).find
		1.upto(listCountry.length) { |i|
			puts "#{i}: #{listCountry[i-1].getLabel}"
		}
		cou_id = (ask "Your choice").to_i
		country = CountryQuery.new.getPk listCountry[cou_id-1].getId

		puts "Choose a team to train :"

		listTeam = TeamQuery.new.filterByCountry(country).find
		1.upto(listTeam.length) {  |i|
			puts "#{i} : #{listTeam[i-1].getLabel}"
		}
		tea_id = ask "Your choice"
		team = TeamQuery.new.getPk listTeam[tea_id.to_i-1].getId

		puts team.to_s

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

