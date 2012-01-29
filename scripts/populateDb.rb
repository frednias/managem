#!/usr/bin/env ruby

require 'fileutils'
require 'sqlite3'
require 'net/http'

# fake User agent
ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75     Safari/535.7'

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
			tea_title varchar(255),
			tea_cou_id INTEGER
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

	#populate team for France
	h = Net::HTTP.new 'fr.wikipedia.org', 80
	resp = h.get( '/w/index.php?title=Mod%C3%A8le:Palette_%C3%89quipes_du_championnat_de_France_de_football_D1&action=raw', {'User-agent' => ua, 'accept-encoding' => 'identity'})
	resp.body.scan(/\[\[([^:\]\]]*)\]\]/)[2..99].each do |entry|
		title, label = entry[0].split(/\|/)
		unless label
			label = title
		end
		title.gsub!("'","''")
		label.gsub!("'","''")
		sql = "insert into tea_team (tea_label,tea_title,tea_cou_id) values ('#{label}','#{title}',1)"
		db.execute sql
	end

	db.execute( "select * from tea_team" ) do |row|
		puts "#{row[0]} = #{row[1]} (#{row[2]})"
	end
end
