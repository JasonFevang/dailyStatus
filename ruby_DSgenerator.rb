#Ruby Daily Status Generator
#Author: Jason Fevang

#Create another daily status with changed date and the previous day's todo's in the
#yesterday section


#dailyStatusyy/mm/dd
require 'date'

class DS
	def initialize
		@today = Date.today
	end

	def day(date) #returns day of the month as dd
		dsDay = date.day.to_s
		
		return "0" + dsDay if dsDay.to_i < 10
		return dsDay
	end

	def month(date) #returns month of the year as mm
		dsMonth = date.mon.to_s
		
		return "0" + dsMonth if dsMonth.to_i < 10
		return dsMonth
	end

	def year(date) #returns year as yyyy
		date.year.to_s[2,2]
	end

	def DS_filename(date) 
		#Replaced / with : because the file system reads them that way when searching files
		"dailyStatus" + self.year(date) + ":" + self.month(date) + ":" + self.day(date) + ".txt" 
	end

	def DS_date(date)
		self.year(date) + "-" + self.month(date) + "-" + self.day(date) + "\n"
	end


	def previous_DS_filename #finds the most recent daily status, skips weekends and off days
		i=0
		begin
			i+=1
		 	ds_filename = DS_filename(@today-i)
		end while !File.exist?(ds_filename)
		return ds_filename
	end

	def get_previous_tasks
		start_copying = "*Working on today:*\n"
		stop_copying = "*Any blockers?*\n"
		@copying = false # only works if I initialize it's type
		@copied_text = "" # only works if I initialize it's type
		File.open(self.previous_DS_filename, "r") do |f|
			f.each_line do |line|
				if line == stop_copying #condition to stop copying
					@copying = false
				end

				if @copying #copy file to @copied_text
					@copied_text << line # concatenates line to @copied_text
				end

				if line == start_copying #condition to start copying
					@copying = true
				end
			end
		end
		return @copied_text.to_s
	end

	def print_ds_status
		newDS = File.open(self.DS_filename(@today), "w")
		newDS.puts "-------------------------------------\n*Status Update*: " + 
		self.DS_date(@today) +
		"*Worked on yesterday:*\n" +
		get_previous_tasks +
		"*Working on today:*\n1. \n\n*Any blockers?*\nNo\n-------------------------------------"
		
		#Print status to terminal
		puts "-------------------------------------\n*Status Update*: " + 
		self.DS_date(@today) +
		"*Worked on yesterday:*\n" +
		get_previous_tasks +
		"*Working on today:*\n1. \n\n*Any blockers?*\nNo\n-------------------------------------"
	end

	def create_new_DS
		if File.exist?(DS_filename(@today))
			if File.exist?(DS_filename(@today+1))
				puts "today's and tomorrow's status already exists"
			else
				@today += 1
				puts "Today's status already exists, creating tomorrow's status"
				print_ds_status
			end
		else
			print_ds_status
		end
	end
end

DS1 = DS.new
puts DS1.month(Date.today)
puts DS1.month(Date.today+230)
puts DS1.day(Date.today)
puts DS1.day(Date.today-10)
puts DS1.year(Date.today)
# puts DS1.DS_filename(Date.today)
# puts DS1.DS_date(Date.today)
# puts DS1.previous_DS_filename
# puts DS1.get_previous_tasks
#DS1.print_ds_status
# DS1.create_new_DS
