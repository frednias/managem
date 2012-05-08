require 'yaml'
require 'lib/team.rb'

class Home < WebApplication

	def initialize
		if File.directory?("data/games/running")
			running
		else
			d = Dir["data/games/*"]
			if d.length > 0
				@tpl = 'gamelist'
				@title =  'Liste des parties'
				@games = Game.new.getList
			else
				@tpl = 'newgame'
				@title = 'Nouvelle partie'
				@teams = TeamQuery.new.find
			end
		end
	end

	def running
		@tpl = 'run'
		@title = 'Partie en cours'
		@game = Game.new.load
	end

	def newgame
		@tpl = 'newgame'
		@title = 'Nouvelle partie'
		@teams = TeamQuery.new.find
		self
	end
end

