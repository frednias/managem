require 'yaml'
require 'lib/team.rb'

class Home < WebApplication

	def initialize
		if File.directory?("data/games/running")
			running
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

	def running
		@tpl = 'run'
		@title = 'Partie en cours'
		param = YAML::load(File.read('data/games/running/manager.yaml'))
		@party = param['ident']
	end
end

