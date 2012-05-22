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
        end

        def getId
                @id
        end

	def load id
		puts "loading " + id.to_s 
	end
	def initialize
		puts "initialize"
	end

	def find
		list = []
		init
		sql = "select * from #{@table}"
		@db.results_as_hash = true
		row = @db.execute2(sql) 
		1.upto(row.length-1) do |i|
			c = self.class.new
			row[0].each do |col|
				c.setValue col , row[i][col]
			end
			list.push c
		end
		list
	end
	
	def setValue( key , value )
		@infos[key][1] = value
	end
end

