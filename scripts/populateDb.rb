#!/usr/bin/env ruby

require 'fileutils'
require 'sqlite3'
require 'net/http'

require 'lib/activerecord'
require 'lib/team'
require 'lib/country'

# fake User agent
ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7'

# restart from scratch
FileUtils.rm_rf './data/init'
Dir.mkdir './data/init'

db = SQLite3::Database.new( './data/init/data.db' )

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

	Country.new('Espagne').save
	Country.new('Angleterre').save
	Country.new('Italie').save
	Country.new('Allemagne').save


Country.new.find.each do |c|
	puts c.getName
end


	c = Country.new 'France'
	c.setPlayable 1
	c.save
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

		t = Team.new
		t.setName label
		t.setTitle title
		t.setCountry c.getId
		t.save
	end


	db.execute( "select * from tea_team" ) do |row|
		puts "#{row[0]} = #{row[1]} (#{row[2]})"
	end


Team.new.find.each do |t|
	puts t.getName
end
	


