
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
		FileUtils.mv( "./data/run" , "./data/games/#{@name}" )
	end

	def run
	end
end

