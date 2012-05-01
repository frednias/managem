require 'sqlite3'

class Country
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
	def setPlayable playable
		@playable = playable
	end
end

class CountryQuery
	def initialize
		@mapFunction = {
			'cou_id' => 'setId',
			'cou_label' => 'setLabel',
			'cou_playable' => 'setPlayable'
		}
		@condition = []
		@list = []
	end

	def filterByPlayable(playable)
		@condition.push ['cou_playable',playable]
		self
	end

	def find
		s = "select * from cou_country where 1"
		@condition.each do |c|
			s = "#{s} AND #{c[0]} = #{c[1]}"
		end
		db = SQLite3::Database.new( "./data/run/data.db" )
			db.results_as_hash = true
			row = db.execute2(s)
			1.upto(row.length-1) do |i|
				c = Country.new
				row[0].each do |col|
					c.send( @mapFunction[col], row[i][col])
				end
				@list.push c
			end
		@list
	end

	def getPk cou_id
		c = Country.new
		s = "select * from cou_country where cou_id = #{cou_id}"
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

