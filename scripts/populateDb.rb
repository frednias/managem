#!/usr/bin/env ruby

require 'fileutils'
require 'sqlite3'

# restart from scratch
FileUtils.rm_rf './data/init'
Dir.mkdir './data/init'

SQLite3::Database.new( './data/init/data.db' ) do |db|

	db.execute('
		CREATE TABLE 
			cou_country
		(
			cou_id INTEGER CONSTRAINT pk PRIMARY KEY AUTOINCREMENT,
			cou_label varchar(255),
			cou_playable INTEGER
		)
	')

	db.execute("insert into cou_country (cou_label,cou_playable) values ('France',1)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Espagne',0)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Italie',0)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Allemagne',0)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Angleterre',0)")

	db.execute( "select * from cou_country" ) do |row|
		puts "#{row[0]} = #{row[1]}"
	end
end
