class ActiveRecord
	def init
                unless @db
                        @db = SQLite3::Database.new( './data/init/data.db' )
                end
	end
        def save
		init
                if @id
                        puts "update #{@table} set"
                else
                        sql = "insert into #{@table} ("

                        @infos.each do |i|
                                if i[0] != @pk
					sql = sql +  i[0].to_s + ','
				end
                        end

                        sql = sql.chomp(',') + ') values ('

                        @infos.each do |i|
                                if i[0] != @pk
					sql = sql + "'" + i[1][1].to_s + "'" + ','
				end
                        end

                        sql = sql.chomp(',') + ')'
                end

                @db.execute sql
                @id = @db.last_insert_row_id
		@infos[@pk][1] = @id
        end

        def getId
                @id
        end
	def setId id
		@id = id
	end
	def getPk
		@pk
	end

	def load id
		puts "loading " + id.to_s 
	end
	def initialize
		puts "initialize"
	end

	def find params = nil
		list = []
		init
		sql = "select * from #{@table} where 1 "
		if params
			params.each do |param|
				sql = sql + "and #{param[0]} = #{param[1]} "
			end
		end
		@db.results_as_hash = true
		row = @db.execute2(sql) 
		1.upto(row.length-1) do |i|
			c = self.class.new
			row[0].each do |col|
				c.setValue col , row[i][col]
				if col == c.getPk
					c.setId row[i][col]
				end
			end
			list.push c
		end
		list
	end
	
	def setValue( key , value )
		@infos[key][1] = value
	end
end

