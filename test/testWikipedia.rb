require 'net/http'

ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75     Safari/535.7'
# http://fr.wikipedia.org/w/index.php?title=Mod%C3%A8le:Palette_%C3%89quipes_du_championnat_de_France_de_football_D1&action=edit

h = Net::HTTP.new 'fr.wikipedia.org', 80

resp = h.get( '/w/index.php?title=Mod%C3%A8le:Palette_%C3%89quipes_du_championnat_de_France_de_football_D1&action=raw', {'User-agent' => ua, 'accept-encoding' => 'identity'})

body = resp.body

#puts body.split(/div>\n/)[1].split(/&nbsp;..../)
body.scan(/\[\[([^:\]\]]*)\]\]/)[2..99].each do |entry|
	puts "found #{entry[0]}"
end

	#puts "Code = #{resp.code}"
	#puts "Message = #{resp.message}"
	#resp.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
