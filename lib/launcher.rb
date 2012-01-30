
class Launcher
	def initialize
		@games = Dir["data/games/*"]
		FileUtils.rm_rf "./data/run"
		Dir.mkdir "./data/run"
	end

	def startNewGame

		FileUtils.cp( "./data/init/data.db" , "./data/run/data.db" )

		puts "Starting new Game..."

		man = Manager.new
		man.setFirstName(ask "First Name")
		man.setLastName(ask "Last Name")

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
		man.setTeam team

		puts team.to_s

		game = Game.new
		game.setManager(man)
		
		f = File.new('./data/run/manager','w')
		f.puts man.getFirstName
		f.puts man.getLastName
		f.puts man.getTeam.getId
		f.close

		return game
	end

	def loadOldGame (choice)

		FileUtils.cp( "#{@games[choice.to_i-1]}/data.db" , "./data/run/data.db" )
		FileUtils.cp( "#{@games[choice.to_i-1]}/manager" , "./data/run/manager" )

		puts 'Get old game'

		f = File.new("#{@games[choice.to_i-1]}/manager",'r')
		firstName = f.gets.chomp
		lastName = f.gets.chomp
		tea_id = f.gets.chomp.to_i

		man = Manager.new
		man.setFirstName firstName
		man.setLastName lastName
		man.setTeam TeamQuery.new.getPk tea_id

		game = Game.new
		game.setManager(man)

		puts "Your Name : #{firstName} #{lastName}"
		puts "You are training " + man.getTeam.getLabel

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

		return game
	end

end

