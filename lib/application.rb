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
			#puts "matching #{path} with #{method[1].sub('{id}','(\w+)')}"
			if path.match( method[1].sub('{id}','(\w+)'))
				size = path.match( method[1].sub('{id}','(\w+)')).length
				if size > 1
					method[2].call path.match( method[1].sub('{id}','(\w+)'))[1]
				end
			end
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

