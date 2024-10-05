# popmart_tracker_logic.rb

# Contains the logic/backend portion of the the popmart tracker application.
# This functionality will be contained in the PopTrackLogic class.

# Require statements
require_relative "popmart_set.rb"

class PopTrackLogic
    # PopTrackLogic is a class that is used for handling the logical portions of the
    # Popmart Tracker application. This includes tasks such as writing to files, 
    # checking user commands, returning information that the uswer wants to look at, etc.

    # It has two instance variables and one class constant:

    # @file_path - the path of the file that PopTrackLogic will interact with
    # @sets - a hash containing all of the Popmart Sets that the user wants to store
    #         * The keys will be the brand name + the series name of the Popmart set
    #         * The values will be PopMartSet objects
    # VALID_COMMAND_HASH - Hash containing the commands that the user is allowed to do
    attr_reader :sets

    VALID_COMMAND_HASH = {"ADD SET" => true}
    VALID_COMMAND_HASH.default = false


    # The constructor for the PopTrackLogic class
    def initialize(file_path)
        @sets = Hash.new
        @file_path = file_path
    end

    # Checks to see if the string given to it is a valid command within VALID_COMMAND_HASH.
    def is_valid_command?(user_comm)
        return VALID_COMMAND_HASH[user_comm.upcase]
    end

    # Needs to be given a PopMartSet object. Adds it to the @sets hash.
    def add_set(popmart_set)
        key = popmart_set.brand + "_" + popmart_set.series_name
        @sets[key.upcase] = popmart_set
    end

    def add_to_specific_set(set_name, popmart_figure)
        @sets[set_name].add_figure(popmart_figure)
        # NEEDS TESTS
    end

end
