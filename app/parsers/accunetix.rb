require "rexml/document"
include REXML

class AccunetixXMLParser
	
	
	def initialize(debug = false)
		@debug = debug
		@hosts = Array.new
		reset_state		
	end
	
	def reset_state()
		@host = {
			'hostname' => nil, 
			'banner' => { 'webserver' => nil, 'operatingsys' => nil, 'technologies' => nil },
			'vulnerabilities' => [ 'vulnerability' => {
									'name' => nil, 'description' => nil, 'affects' => nil,
									'resolution' => nil,
									'references' => [ 
									 'ref' => {'title' => nil, 'link' => nil}]
			}]
			
		 }
		 
		 @x = Hash.new
		 @ref = Hash.new
		 @state = :ignore

	end
	
	def tag_start(name, attributes)
		
		case name
		
		when "ScanGroup"
			@state = :scangroup
			debug "starting scangroup"

		when "Scan"
			@state = :scan
			debug "starting scan"				
				
		when "StartURL"
			@state = :starturl
			debug "starting starturl"		

		when "Banner"
			@state = :banner

		when "Os"
			@state = :os

		when "WebServer"
			@state = :webserver
			
		when "Technologies"
			@state = :technologies
			
		when "ReportItems"
			@state = :ignore
			@host['vulnerabilities'].pop
			debug "starting reportitems"		

		when "ReportItem"
			@state = :reportitem
			@x = Hash.new
			@ref = Hash.new
			
			debug "starting reportitem"
			
		when "Name"
			@state = :name
			
		when "Details"
			@state = :details
		
		when "Affects"
			@state = :affects
			
		when "Description"
			@state = :description
			
		when "Recommendation"
			@state = :recommendation
			
		when "Request"
			@state = :request
			
		when "Response"
			@state = :response
			
		when "Database"
			@state = :database
			
		when "URL"
			@state = :url
				
		else 
			@state = :ignore		
		end			
	end
	
	def tag_end(name)
		case name
			
		when "ScanGroup"
			#puts @hosts.inspect
			debug "ending scangroup"
			exit

		when "Scan"
			reset_state
		
		when "ReportItem"
			
			@x['references'] = @ref
			@host['vulnerabilities'].push @x

		when "ReportItems"
			pretty_print(@host)
		end
	end
	
	def text(str)
	end
	
	def cdata(str)
		if str == nil
			str = "N/A"
		end
		
		case @state
			
		when :starturl
			@host["hostname"] = str
			
		when :banner
			@host['banner']['webserver'] = str
			
		when :os
			@host['banner']['operatingsys'] = str
			
		when :webserver
			@host['banner']['webserver'] = str

		when :technologies
			@host['banner']['technologies'] = str
			
		when :name
			@x['name'] = str

		when :details
			@x['description'] = str 
		when :affects
			@x['affects'] = str
			
		when :description
			@x['description'] << " " + str

		when :recommendation
			@x['resolution'] = str
		
		when :request
#			@x['request'] = str

		when :response
#			@x['response'] = str
  
		when :database
			@ref['title'] = str
		
		when :url
			@ref['link'] = str
		else 
			debug "ignored tag"
		end
		
	end
	
	def debug(str)
		if @debug == true
			puts str
		end
	end
	
	
	def pretty_print(data)
		puts "Host: " + data['hostname'] 
		puts "WebServer: " + data['banner']['webserver'] 
		puts "Operating System: " + data['banner']['operatingsys'] 
		puts "Vulnerabilities: "
		
		data['vulnerabilities'].each do |x|
			puts "\tName: " + x['name']
			puts "\tDescription: " 
			len = x['description'].length
			space = 0 
						
			for i in 0..len

				if x['description'][i].chr == " "
					space = space + 1
				end
				
				if x['description'][i].chr == "\n"
					x['description'].insert(i+1, "\t\t")
				end
				if (space > 10)
					x['description'].insert(i+1, "\n")
					space = 0 
				end
			end
			puts "\t\t" + x['description'].gsub("<br\>", "\n").gsub(/<\/?[^>]*>/, "")+ "\n\n"			
			puts "\tAffects: " + x['affects']  + "\n\n"
		end
		puts "\n"
		
	end
	
	
	def xmldecl(version, encoding, standalone); end
	def comment(str); end
	def instruction(name, instruction); end
	def attlist; end
	
end

data = File.new('export.xml')
doc = Document.parse_stream(data, AccunetixXMLParser.new(false))