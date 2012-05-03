#!/usr/bin/env ruby

require 'lib/conf'
require 'lib/autoload'
require 'lib/application'
require 'cgi'

app = Application.new

app.get('/', proc {
	h = Home.new.display
})

app.post('/new', Proc.new { |data|
	print "Content-type: text/plain\r\n\r\n"
	g = Game.new.create data
})

app.get('/quit', proc {
	Game.new.quit
	print "Location: http://nias.fr/managem\r\n"
	print "Content-type: text/plain\r\n\r\n"
})

app.run

