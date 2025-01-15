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

    VALID_COMMAND_HASH = {"ADD SET" => true, "QUIT" => true, "HELP" => true, "ADD FIGURE" => true, "MARK FIGURE" => true, "VIEW SET" => true, "VIEW FIGURE" => true, "DELETE FIGURE" => true, "DELETE SET" => true}
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
            add_set()
        when "HELP"
            print_help_file()
        when "ADD FIGURE"
            add_figure()
        when "MARK FIGURE"
            mark_figure()
        when "VIEW SET"
            view_set()
        when "VIEW FIGURE"
            view_figure()
        when "DELETE FIGURE"
            delete_figure()
        when "DELETE SET"
            delete_set_command()
        end
    end
    
    # Handles ADD SET command
    def add_set 
        new_set = get_new_set_info
        @tracker.add_set(new_set);
        puts "\nSet #{new_set.brand} #{new_set.series_name} created with price #{new_set.price}"
        puts
    end
	
    # Gets information about the set the user wants to add.
    # Returns a PopMartSet object with that information.
    def get_new_set_info
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
	
    # Begins the process of adding a figure to a specified set 
    def add_figure
        while true
            print_header("ADD FIGURE")
            existing_set = prompt_for_set_name
            set_key = @tracker.generate_dict_key(existing_set.brand, existing_set.series_name)

            print "#{existing_set.brand} #{existing_set.series_name} was found\n\n"

            new_figure = prompt_for_new_figure

            if can_add_figure?(set_key, new_figure)
                puts "Figure #{new_figure.name} added to #{existing_set.brand} #{existing_set.series_name}"
                puts
                break
            end

            puts
        end
    end
	
    # Prompts the user for the series and brand name of a set
    # If the set does exist, return it. If not, print the error
    # message and make them try again.
    def prompt_for_set_name	
        while true
            print "Set Brand: " 
            brand = gets.chomp

            print "Set Series Name: " 
            series_name = gets.chomp

            begin
                return @tracker.get_set(brand, series_name)
            rescue => error
                puts error.message
                puts
            end
        end
    end
	
    # Prompts user for information about the new figure that
    # will be added. Returns a PopMartFigure object.
    def prompt_for_new_figure
        print "Figure Name: "
        figure_name = gets.chomp
        figure_probability = get_probability_input
        figure_is_collected = get_yes_or_no_answer("Have you collected this figure?")
        figure_is_secret = get_yes_or_no_answer("Is this figure a secret?")

        print "\nFigure Info => #{figure_name}, #{figure_probability}, #{figure_is_collected}, #{figure_is_secret}\n"
        return PopMartFigure.new(figure_name, figure_probability, figure_is_collected, figure_is_secret)
    end
	
    # Prompts for a figure's probability. Will continually ask the
    # the user until they input a suitable value.
    def get_probability_input
        probability = 0.0

        while true
            print "Figure Probability: "
            input = gets.chomp

            if valid_probability?(input)
                probability = Rational(input).to_f
                return probability
            else
                puts "Invalid probability input, try again."
                puts
            end
        end
    end
	
    # Checks that a given input is a valid probability.
    # An input is considered valid if it is convertible to a Float,
    # and is in between 0 and 1.
    def valid_probability?(prob_input)	
        begin
            number = Rational(prob_input)
            return (0.0 < number && number < 1)
        rescue ArgumentError
            return false
        end
    end
	
    # Asks the user to input "yes" or "no" to whatever question is being
    # asked by the prompt variable. Returns true if yes, returns false if
    # no. If neither answer is given, ask the user a second time.
    def get_yes_or_no_answer(prompt)
        while true
            print "#{prompt} (Y/N): "
            input = gets.chomp.downcase

            case input
            when "y"
                return true
            when "yes"
                return true
            when "n"
                return false
            when "no"
                return false	
            else
                puts "Invalid input. Try again."
                puts
            end
        end
    end
	
    # Checks to see if the figure_to_be_added can be added to the set
    # represented by set_key. If it can, return true. If not, prints
    # out the error message and return false.
    def can_add_figure?(set_key, figure_to_be_added)
        begin
            @tracker.add_to_specific_set(set_key, figure_to_be_added)
            return true
        rescue => error
            puts error.message
            return false
        end
    end
	
    # Executes the "MARK FIGURE" command
    def mark_figure 
        while true
            print_header("MARK FIGURE")
            existing_set = prompt_for_set_name
            existing_figure = prompt_for_figure_name
            existing_set_key = @tracker.generate_dict_key(existing_set.brand, existing_set.series_name)
            
            if can_mark_figure?(existing_set_key, existing_figure)
                puts "#{existing_figure} marked as collected"
                puts
                break 
            end

            puts
        end 
    end
	
    # Prompts user for the name of the figure they want to edit
    # Returns whatever the user inputs
    def prompt_for_figure_name
        print "\nEnter figure name: "
        figure_name = gets.chomp

        return figure_name
    end
    
    # Takes in a set and a figure's name. Marks the figure within the set
    # as collected and returns true. If the figure does not exist in 
    # the set, print an error message and return false.
    def can_mark_figure?(set_key, figure_name)
        begin
           @tracker.mark_figure_in_specified_set(set_key, figure_name)
           return true
        rescue => error
            puts error.message
            return false
        end
    end
    
    # Print out the information of a specific set
    def view_set
        print_header("VIEW SET")
        existing_set = prompt_for_set_name
        print "\n#{existing_set}\n\nFigures:\n"
        existing_set.print_figure_names
        puts
    end
    
    # Print out the information of a specific figure
    def view_figure
        while true
            print_header("VIEW FIGURE")
            existing_set = prompt_for_set_name
            existing_figure = prompt_for_figure_name

            if can_print_figure?(existing_set, existing_figure)
                puts
                break
            end
        end 
    end
    
    # Checks to see if the figure exists. If it does, print it and
    # return true. Else, print an error message and print false
    def can_print_figure?(set, figure_name)
        found_figure = set.find_figure(figure_name)

        if !(found_figure.nil?)
            puts "\n#{found_figure}"
            return true
        else
            puts "\n#{figure_name} not found!"
            return false
        end
    end
    
    # Executes the DELETE FIGURE command
    def delete_figure
        print_header("DELETE FIGURE")

        existing_set = prompt_for_set_name
        existing_set_key = @tracker.generate_dict_key(existing_set.brand, existing_set.series_name)
        existing_figure = prompt_for_figure_name
        
        confirmation = get_yes_or_no_answer("Are you sure you want to delete #{existing_figure} from set #{existing_set.brand} #{existing_set.series_name}")

        if confirmation
            puts "\nDeleting figure.."
            can_delete_figure?(existing_set_key, existing_figure)
        else
            puts "\nCancelling Delete Operation"
        end

        puts
    end
    
    # Needs to be given a set key and the name of a PopMartFigure object.
    # Checks to see if the figure can be deleted. If it can be, execute
    # the deletion. If not, print an error.
    def can_delete_figure?(set_key, figure_name)
        begin
           @tracker.delete_figure_in_specified_set(set_key, figure_name)
           puts "Completed Delete!"
        rescue => error
            puts error.message
        end
    end
    
    # Executes the DELETE SET command. This one does not follow
    # the same naming convention as the other methods because
    # I already used the name "delete_set", and naming is hard.
    def delete_set_command
        print_header("DELETE SET")

        set = prompt_for_set_name
        confirm_delete = get_yes_or_no_answer("Are you sure you want to delete the set #{set.brand} #{set.series_name}")

        if confirm_delete
            puts "\nDeleting Set..."
            @tracker.delete_set(set.brand, set.series_name)
            puts "Completed Delete!"
        else
            puts "\nCancelling Delete Operation" 
        end

        puts
    end    

end
