# popmart_tracker_ui.rb


# File contains the PopTrackUI class which is responsible for displaying
# the Popmart Tracker application and receiving user inputs


# Require statements
require_relative "popmart_tracker_logic.rb"


class PopTrackUI
	# PopTrackUI is a class that will be used for handling the UI portion
	# of the Popmart Tracker application. This includes tasks such as: 
	# collecting user inputs and displaying results.
	
	# @tracker - PopTrackLogic object, handles backend side of the program
	# @running - Boolean, determines whether or not the program is still active
    # VALID_COMMAND_HASH - Hash containing the commands that the user is allowed to do

	VALID_COMMAND_HASH = {"ADD SET" => true, "QUIT" => true}
    VALID_COMMAND_HASH.default = false	

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
		puts
	end
	
	# Checks to see if the string given to it is a valid command within VALID_COMMAND_HASH.
    def is_valid_command?(user_comm)
        return VALID_COMMAND_HASH[user_comm.upcase]
    end

	# Runs the popmart tracker. Gets user's input and verifies that it is a 
	# valid command. If it is, then execute it. If not, warn the user. Repeats
	# this action until @running is false.
	def run_tracker
		while @running
			print "INPUT: "
			input = gets.chomp
			
			if is_valid_command?(input)
				execute_command(input)
			else
				puts "Invalid command, try again!"
			end
		end
	end
	
	# Needs to be given the user's input as a string. Determines which
	# command the user wants to carry out and performs it.
	def execute_command(input)
		command = input.upcase

		case command
		when "QUIT"
			@running = false
			puts "\nExited Popmart Tracker"
		when "ADD SET"
			new_set = getSetInfo()
			puts "Set #{new_set.brand} #{new_set.series_name} created with price #{new_set.price}"
			puts
		end
	end

	def getSetInfo
		puts("\nPlease enter the set information:")
		
		print("Brand: ")
		brand = gets.chomp

		print("Series Name: ")
		series_name = gets.chomp
		
		price = get_price_input

		return PopMartSet.new(brand, series_name, price)
	end

	def get_price_input
		price = nil
		
		while true
			print "Price: "
			input = gets.chomp

			if input == ""
				break
			elsif can_convert_price_input?(input)
				price = input.to_f	
				break
			else
				puts "Invalid input for price, please try again."
				puts
			end
		end

		return price
	end

	def can_convert_price_input?(price_input)
		begin
			number = Float(price_input)
			return true
		rescue ArgumentError
			return false
		end
	end
end
