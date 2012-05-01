require 'erb'

class WebApplication

	def initialize
	end

	def display
		print "Content-type: text/html\r\n\r\n"
		header = ERB.new(IO.readlines("app/views/header.erb",nil)[0])
		header.run(binding)

		tpl = ERB.new(IO.readlines("app/views/#{@tpl}.erb",nil)[0])
		tpl.run(binding)

		footer = ERB.new(IO.readlines("app/views/footer.erb",nil)[0])
		footer.run(binding)
	end
end

