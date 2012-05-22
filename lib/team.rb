require 'sqlite3'

class Team < ActiveRecord
        def initialize
                @table = 'tea_team'
		@pk = 'tea_id'
                @infos = {
			'tea_id' => [ 'int' , nil ] ,
                        'tea_label' => [ 'string' , '' ] ,
                        'tea_title' => [ 'string' , '' ] ,
                        'tea_cou_id' => [ 'int' , nil ]
                }
        end
        def setName name
                @infos['tea_label'][1] = name
        end
	def getName
		@infos['tea_label'][1]
	end

        def setTitle title
                @infos['tea_title'][1] = title
        end

        def setCountry cou_id
                @infos['tea_cou_id'][1] = cou_id
        end
end

class TeamQuery
	def initialize
		@mapFunction = {
			'tea_id' => 'setId',
			'tea_label' => 'setName',
			'tea_title' => 'setTitle',
			'tea_cou_id' => 'setCountry'
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

		db = SQLite3::Database.new( "data/run/data.db" ) 
			db.results_as_hash = true
			row = db.execute2(s)
			1.upto(row.length-1) do |i|
				c = Team.new
				row[0].each do |col|
					c.send( @mapFunction[col], row[i][col])
				end
				@list.push c
			end
		@list
	end

	def getPk tea_id
		c = Team.new
		s = "select * from tea_team where tea_id = #{tea_id}"
		db = SQLite3::Database.new( "./data/run/data.db" )
			db.results_as_hash = true
			row = db.execute2(s)
			1.upto(row.length-1) do |i|
				row[0].each do |col|
					c.send( @mapFunction[col], row[i][col])
				end
			end
		return c
	end
end

