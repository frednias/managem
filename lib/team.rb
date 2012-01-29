require 'sqlite3'

class Team
	def setId id
		@id = id
	end
	def getId
		@id
	end
	def setLabel label
		@label = label
	end
	def getLabel
		@label
	end
	def setTitle title
		@title = title
	end
	def getTitle
		@title
	end

	def setCouById cou_id
		@country = CountryQuery.new.getPk cou_id
	end

	def to_s
		"I am [#{@id}] #{@label} in #{@country.getLabel}"
	end
end

class TeamQuery
	def initialize
		@mapFunction = {
			'tea_id' => 'setId',
			'tea_label' => 'setLabel',
			'tea_title' => 'setTitle',
			'tea_cou_id' => 'setCouById'
		}
		@condition = []
		@list = []
	end

	def filterByCountry country
		@condition.push ['tea_cou_id',country.getId]
		self
	end

	def find
		s = "select * from tea_team where 1"
		@condition.each do |c|
			s = "#{s} AND #{c[0]} = #{c[1]}"
		end
		SQLite3::Database.new( "./data/run/data.db" ) do |db|
			db.results_as_hash = true
			row = db.execute2(s)
			1.upto(row.length-1) do |i|
				c = Team.new
				row[0].each do |col|
					c.send( @mapFunction[col], row[i][col])
				end
				@list.push c
			end
		end
		@list
	end

	def getPk tea_id
		c = Team.new
		s = "select * from tea_team where tea_id = #{tea_id}"
		SQLite3::Database.new( "./data/run/data.db" ) do |db|
			db.results_as_hash = true
			row = db.execute2(s)
			1.upto(row.length-1) do |i|
				row[0].each do |col|
					c.send( @mapFunction[col], row[i][col])
				end
			end
		end
		return c
	end
end

