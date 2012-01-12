
class Game
	def initialize
	end

	def setManager manager
		@manager = manager
	end

	def setName name
		@name = name
	end

	def save
		FileUtils.rm_rf "./data/games/#{@name}"
		FileUtils.mv( "./data/games/run" , "./data/games/#{@name}" )
	end

	def run
		Dir.mkdir "./data/games/run"
		f = File.new('./data/games/run/manager','w')
		f.puts @manager.getFirstName
		f.puts @manager.getLastName
		f.close
	end
end

