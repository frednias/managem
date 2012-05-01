class Application

	def initialize
		@methods = []
	end

	def get(path,block)
		@methods.push ['GET',path,block]
	end

	def post(path,block)
		@methods.push ['POST',path,block]
	end

	def run
		path = ENV["REQUEST_URI"].sub(Managem::Path,'').sub('?','')
		res = false
		@methods.each do |method|
			if method[1] == path
				res = true
				if method == 'GET'
					method[2].call
				else
					method[2].call CGI.new
				end
			end
		end
		if res == false
			puts "not  found"
		end
	end
end

