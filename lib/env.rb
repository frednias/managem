class Env

	def self.install
		unless File.directory?('./data')
			Dir.mkdir "./data"
		end
		unless File.directory?('./data/games')
			Dir.mkdir "./data/games"
		end
	end
end

