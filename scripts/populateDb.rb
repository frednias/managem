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
	db.execute('
		CREATE TABLE 
			tea_team
		(
			tea_id INTEGER CONSTRAINT pk PRIMARY KEY AUTOINCREMENT,
			tea_label varchar(255),
			tea_cou_id INTEGER
		)
	')

	db.execute("insert into cou_country (cou_label,cou_playable) values ('France',1)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Espagne',1)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Italie',0)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Allemagne',0)")
	db.execute("insert into cou_country (cou_label,cou_playable) values ('Angleterre',0)")

	db.execute( "select * from cou_country" ) do |row|
		puts "#{row[0]} = #{row[1]}"
	end

	db.execute("insert into tea_team (tea_label, tea_cou_id) values ('FC Nantes', 1)")
	db.execute("insert into tea_team (tea_label, tea_cou_id) values ('FC Barcelone', 2)")

	db.execute( "select * from tea_team" ) do |row|
		puts "#{row[0]} = #{row[1]}"
	end
end
