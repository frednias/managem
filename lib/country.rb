require 'sqlite3'

class Country < ActiveRecord
        def initialize name = nil
                @table = 'cou_country'
                @row = [ {'col'=>'cou_label','var'=>'label','type'=>'string'} , {'col'=>'cou_playable','var'=>'playable','type'=>'int'} ]
		@pk = 'cou_id'
                @infos = {
			'cou_id' => [ 'int' , nil ] ,
                        'cou_label' => [ 'string' , '' ] ,
                        'cou_playable' => [ 'int' , 0 ]
                }

                if name
                        self.setName  name
                end
        end
        def setName name
                @infos['cou_label'][1] = name
        end
	def getName
		@infos['cou_label'][1]
	end

        def setPlayable playable
                @infos['cou_playable'][1] = playable
        end
end

class CountryQuery
	def initialize
		@mapFunction = {
			'cou_id' => 'setId',
			'cou_label' => 'setName',
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

