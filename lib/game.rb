require 'yaml'
require 'fileutils'

def getFirstDate (year)
        d = Date.new(year,6,30)
        if d.cwday < 3
                j0 = d-14+3-d.cwday
        elsif d.cwday >=3
                j0 = d-7-d.cwday+3
        end
        return j0
end


class Game
	def initialize
	end

	def setManager manager
		@manager = manager
	end

	def setName name
		@name = name
	end
	def getName
		@name
	end
	def getDate
		@date
	end

	def save
		#not used ?
		FileUtils.rm_rf "./data/games/#{@name}"
		FileUtils.mv( "./data/run" , "./data/games/#{@name}" )
	end

	def create data
		params = data.params
		j0 = getFirstDate 2012
		params['date'] = j0
		Dir.mkdir("./data/games/running")
		FileUtils.cp( "data/init/data.db" , "data/games/running/data.db" )
		f = File.open "./data/games/running/manager.yaml", 'w'
		f.puts  YAML::dump(data.params)
		f.close
		setName  data.params['ident']
	end

	def start id
		FileUtils.mv( "data/games/#{id}" , "data/games/running" )
		load
	end
	def quit
		load
		FileUtils.mv( "data/games/running" , "data/games/#{@name}" )
	end

	def load
		param = YAML::load(File.read('data/games/running/manager.yaml'))
		setName  param['ident']
		@date = param['date']
		self
	end

	def getList
		Dir["./data/games/*"]
	end


	def run
		france = CountryQuery.new.getPk 1
		teams = TeamQuery.new.filterByCountry(france).find
		cal = []
		1.upto((teams.count-1)*2) do |n|
			cal[n] = []
		end
		n = teams.count
		1.upto(n) do |i|
			i.upto(n) do |j|

				m = nil

				if j != n and i!=n and i!=j
					if i+j-1 < n
						r=i+j-1
						m = [teams[i-1],teams[j-1]]
					end
					if i+j-1 >= n
						r=i+j-n
						m = [teams[i-1],teams[j-1]]
					end

					if (i+j).modulo( 2) == 0
						m[0] , m[1] = m[1] , m[0]
					end
				end

				if j==n and i!=j
					if 2*i <= n
						r = 2*i-1
						m = [teams[i-1],teams[j-1]]
					end
					if 2*i > n
						r = 2*i-n
						m = [teams[j-1],teams[i-1]]
					end
				end

				if m
					cal[r].push m
				end


			end
		end

		#compute "les matchs retour"
		(teams.count).upto((teams.count-1)*2) do |n|
			1.upto(teams.count/2) do |x|
				cal[n].push [ cal[n-teams.count+1][x-1][1], cal[n-teams.count+1][x-1][0] ]
			end
		end

		reg = []
		1.upto(teams.count) do |t|
			#reg.push {'w'=>0, 'd'=>0, 'l'=>0, 'f'=>0, 'a'=>0}
			reg[t] = {'w'=>0, 'd'=>0, 'l'=>0, 'f'=>0, 'a'=>0}
			#reg[t]['id'] = t	
		end

		1.upto((teams.count-1)*2) do |n|
			puts "day " + n.to_s
			1.upto(cal[n].count) do |x|

				m = Match.new cal[n][x-1][0], cal[n][x-1][1]
				s1,s2 = m.getScores

				reg[cal[n][x-1][0].getId]['f'] = reg[cal[n][x-1][0].getId]['f'] + s1.to_i
				reg[cal[n][x-1][0].getId]['a'] = reg[cal[n][x-1][0].getId]['a'] + s2.to_i
				reg[cal[n][x-1][1].getId]['f'] = reg[cal[n][x-1][1].getId]['f'] + s2.to_i
				reg[cal[n][x-1][1].getId]['a'] = reg[cal[n][x-1][1].getId]['a'] + s1.to_i

				if s1 > s2
					reg[cal[n][x-1][0].getId]['w'] = reg[cal[n][x-1][0].getId]['w'] + 1
					reg[cal[n][x-1][1].getId]['l'] = reg[cal[n][x-1][1].getId]['l'] + 1
				elsif s1 == s2
					reg[cal[n][x-1][0].getId]['d'] = reg[cal[n][x-1][0].getId]['d'] + 1
					reg[cal[n][x-1][1].getId]['d'] = reg[cal[n][x-1][1].getId]['d'] + 1
				else
					reg[cal[n][x-1][0].getId]['l'] = reg[cal[n][x-1][0].getId]['l'] + 1
					reg[cal[n][x-1][1].getId]['w'] = reg[cal[n][x-1][1].getId]['w'] + 1
				end
			end
			1.upto(teams.count) do |t|
				reg[t]['p'] = reg[t]['w']*3 + reg[t]['d']
				reg[t]['g'] = reg[t]['f'] - reg[t]['a']
				reg[t]['id'] = t	
			end
			cla = []
			1.upto(teams.count) do |t|
				cla[t] = reg[t]
			end
			#cla = reg
			1.upto(teams.count-1) do |i|
				i.upto(teams.count) do |j|
					if cla[j]['p'] > cla[i]['p']
						tmp = cla[i]
						cla[i] = cla[j]
						cla[j] = tmp
					elsif  cla[j]['p'] == cla[i]['p']
						if cla[j]['g'] > cla[i]['g']
							tmp = cla[i]
							cla[i] = cla[j]
							cla[j] = tmp
						elsif cla[j]['d'] == cla[i]['d']
							if cla[j]['f'] > cla[i]['f']
								tmp = cla[i]
								cla[i] = cla[j]
								cla[j] = tmp
							end
						end
					end
				end
			end
			1.upto(cla.count-1) do |i|
				puts "#{i} : #{teams[cla[i]['id']-1].getLabel} ... #{cla[i]['p']} - #{cla[i]['w']} #{cla[i]['d']} #{cla[i]['l']} - #{cla[i]['f']} #{cla[i]['a']}  = #{cla[i]['g']} "
			end
		end
	end
end

