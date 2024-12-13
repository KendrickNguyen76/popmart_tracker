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
	
	HELP_FILE = "code/docs/help.txt" 

	VALID_COMMAND_HASH = {"ADD SET" => true, "QUIT" => true, "HELP" => true, "ADD FIGURE" => true}
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

	# Prints out a header that includes the text provided
	def print_header(text)
		puts "\n=====#{text}====="
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
			new_set = get_set_info()
			puts "Set #{new_set.brand} #{new_set.series_name} created with price #{new_set.price}"
			puts
		when "HELP"
			print_help_file()
		when "ADD FIGURE"
			add_figure()
		end
	end
	
	# Gets information about the set the user wants to add.
	# Returns a PopMartSet object with that information.
	def get_set_info
		print_header("ADD SET")
		puts "Please enter the set information:"
		
		print "Brand: "
		brand = gets.chomp

		print "Series Name: "
		series_name = gets.chomp
		
		price = get_price_input

		return PopMartSet.new(brand, series_name, price)
	end
	
	# Asks the user for the set price. If it is a valid price,
	# return the inputted value. If not, ask the user again.
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
	
	# Checks to see if the given input is a valid 
	# value for a price.
	def can_convert_price_input?(price_input)
		begin
			number = Float(price_input)
			return number >= 0.0
		rescue ArgumentError
			return false
		end
	end

	# Prints out each line in HELP_FILE
	def print_help_file
		puts
		File.foreach(HELP_FILE) { |line| puts line }
		puts
	end
	
	def add_figure
		print_header("ADD FIGURE")
		
		print "Set Brand: "
		brand = gets.chomp

		print "Set Series Name: "
		series_name = gets.chomp

		puts "Adding a figure to #{brand} #{series_name}"
		puts
	end
end
