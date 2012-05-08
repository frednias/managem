#!/usr/bin/env ruby

require 'lib/conf'
require 'lib/autoload'
require 'lib/application'
require 'cgi'

app = Application.new

app.get('/', proc {
	h = Home.new.display
})

app.get('/game/start/{id}', Proc.new { |id|
	Game.new.start id
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.post('/new', Proc.new { |data|
	g = Game.new.create data
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.get('/quit', proc {
	Game.new.quit
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.run

