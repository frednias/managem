require 'lib/team.rb'

class Home < WebApplication

	def initialize
		if File.directory?("data/games/running")
			puts 'reprendre la partie courante'
		else
			d = Dir["data/games/*"]
			if d.length > 0
				puts 'liste des parties'
			else
				@tpl = 'newgame'
				@title = 'Nouvelle partie'
				@teams = TeamQuery.new.find
			end
		end
	end

end

