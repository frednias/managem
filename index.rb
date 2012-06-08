#!/usr/bin/env ruby

require 'lib/conf'
require 'lib/autoload'
require 'lib/application'
require 'cgi'
require 'json'

app = Application.new

app.get('/', proc {
	h = Home.new.display
})

app.get('/game/start/{id}', Proc.new { |id|
	Game.new.start id
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.get('/game/edit', proc {
	Home.new.newgame.display
})

app.post('/game/new', Proc.new { |data|
	g = Game.new.create data
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.get('/game/quit', proc {
	Game.new.quit
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.get('/api/clubs/find', proc {
	cgi = CGI.new
	print "Content-type: text/json; charset=UTF-8\r\n\r\n"
	
	teams = Team.new.find cgi.params
	jteam = []
	teams.each do |team|
		jteam.push [ team.getId , team.getName ]
	end
	res = JSON.generate jteam
	print res
})


app.run

