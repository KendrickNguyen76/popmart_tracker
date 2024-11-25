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
		print_start_up()
	end

	def print_start_up
		puts "Welcome to the Popmart Tracker!"
		puts "Please type in \"HELP\" if you need assistance"
	end
end
