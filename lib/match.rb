
class Match

	def initialize team1,team2
		@team1 = team1
		@team2 = team2
	end

	def getScores
		puts @team1.to_s + "(#{@team1.getId})" + ' vs ' + @team2.to_s + "(#{@team2.getId})" + ' ?'
		s = [ Random.rand(4), Random.rand(3)]
		return s
	end
end

