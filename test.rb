#!/usr/bin/env ruby

require 'date'

#printf "Ton pseudo ? "
#name = gets

#print "Welcome #{name}"

class Federation
end

class Player
	def initialize(name)
		@name = name
	end

	def getName
		@name
	end
end

def getFirstDate (year)
	d = Date.new(year,6,30)
	if d.cwday < 3
		j0 = d-14+3-d.cwday
	elsif d.cwday >=3
		j0 = d-7-d.cwday+3
	end
	return j0
end

j0 = getFirstDate 2011

# matchs internationaux euro 2012
# groupes de 6 equipes : 4 dates par semestres, pendant 3 semestres
# 30 matchs
# 12 * 3 = 36 slots, - 6 trous
# barrages : 2 dates dernier semestre

class GroupCalendar
	def initialize
		@matchday = []
	end
	def addMatchday (matchday)
		@matchday.push matchday
	end
	def displayTxt
		puts "Calendar for @name"
		@matchday.each do |m|
			puts m.to_s
		end
	end
end

class GroupCalendarMaker
	def initialize(style)
		@nbteam = 0
		@style = style
		@j = 0
	end

	def setTeam(listTeam)
		@listTeam = listTeam
		@nbteam = @listTeam.count
	end

	def makeCalendar
		gcal = GroupCalendar.new
		m = []
		0.step(@listTeam.count-1,2) do |i|
			m.push [@listTeam[i], @listTeam[i+1]]
		end
		gcal.addMatchday m
		1.upto(@listTeam.count-2) do |j|
			n = []
			n.push [  m[0][0], m[1][0] ]
			1.upto(m.count-2) { |i|
				n.push [ m[i+1][0], m[i-1][1] ]
			}
			n.push [ m[m.count-1][1] , m[m.count-2][1] ]
			gcal.addMatchday n
			m = n
		end
		gcal
	end
end

#g = GroupCalendarMaker.new 'AR'
#g.setTeam ["Nantes", "Paris", "Monaco", "Marseille", "Auxerre", "Bordeaux"]
#gcal = g.makeCalendar
#gcal.displayTxt

t=["Nantes", "Paris", "Monaco", "Marseille", "Auxerre", "Bordeaux", "Lens", "Lyon" ]
t = [1,2,3,4,5,6,7,8,9,nil]
cal = []
1.upto((t.count-1)*2) do |n|
	cal[n] = []
end
n = t.count
1.upto(n) do |i|
	i.upto(n) do |j|

		m = nil

		if j != n and i!=n and i!=j
			if i+j-1 < n
				r=i+j-1
				m = [t[i-1],t[j-1]]
			end
			if i+j-1 >= n
				r=i+j-n
				m = [t[i-1],t[j-1]]
			end

			if (i+j).modulo( 2) == 0
				m[0] , m[1] = m[1] , m[0]
			end
		end

		if j==n and i!=j
			if 2*i <= n
				r = 2*i-1
				m = [t[i-1],t[j-1]]
			end
			if 2*i > n
				r = 2*i-n
				m = [t[j-1],t[i-1]]
			end
		end

		if m
			cal[r].push m
		end


	end
end

1.upto((t.count-1)*2) do |n|
	puts cal[n].to_s
end
