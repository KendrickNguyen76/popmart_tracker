# popmart_tracker_ui.rb


# File contains the PopTrackUI class which is responsible for displaying
# the Popmart Tracker application and receiving user inputs


# Require statements
require_relative "popmart_tracker_logic.rb"


class PopTrackUI
	# PopTrackUI is a class that will be used for handling the UI portion
	# of the Popmart Tracker application. This includes tasks such as: 
	# collecting user inputs and displaying results.
	

	# Constructor for a PopTrackUI object
	def initialize
		@tracker = PopTrackLogic.new
		@running = true
		print_start_up()
		run_tracker()
	end
	
	# Prints the start up message for a popmart tracker program
	def print_start_up
		puts "Welcome to the Popmart Tracker!"
		puts "Please type in \"HELP\" if you need assistance"
	end
	
	# Runs the popmart tracker. Gets user inputs and carries out
	# specific commands based on the input
	def run_tracker
		while @running
			input = gets.chomp
			puts input
		end
	end
end
