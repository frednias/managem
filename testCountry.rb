require 'sqlite3'

class Country
end

class CountryQuery
	def initialize
		@condition = []
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
		SQLite3::Database.new( "./data/init/data.db" ) do |db|
			db.execute(s) do |row|
				c = Country.new
				row.each do |column|
					c.
				end
			end
		end
	end
end

listCountry = CountryQuery.new.filterByPlayable(1).find
exit
1.upto(listCountry.length) { |i|
	puts "#{i}: #{listCountry[i-1]}"
}
exit

SQLite3::Database.new( "data.db" ) do |db|
  #db.execute("create table tbl1(one varchar(10), two smallint)")
  db.execute("insert into tbl1 (one,two) values ('fred', 14)")
  db.execute("insert into tbl1 (one,two) values ('martin', 19)")
  db.execute( "select * from tbl1" ) do |row|
    puts "#{row[0]} = #{row[1]}"
  end
end
