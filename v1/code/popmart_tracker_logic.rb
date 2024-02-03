# popmart_tracker_logic.rb

# Contains the logic/backend portion of the the popmart tracker application.
# This functionality will be contained in the PopTrackLogic class.

class PopTrackLogic
    # PopTrackLogic is a class that is used for handling the logical portions of the
    # Popmart Tracker application. This includes tasks such as writing to files, 
    # checking user commands, returning information that the uswer wants to look at, etc.

    # It has one instance variable and one class constant:

    # @file_path - the path of the file that PopTrackLogic will interact with
    # @sets - a hash containing all of the Popmart Sets that the user wants to store
    # VALID_COMMAND_HASH - Hash containing the commands that the user is allowed to do

    VALID_COMMAND_HASH = {"ADD" => true}
    VALID_COMMAND_HASH.default = false


    # The constructor for the PopTrackLogic class
    def initialize(file_path)
        @sets = Hash.new
        @file_path = file_path
    end

    # Checks to see if the string given to it is a
    # valid command within VALID_COMMAND_HASH.
    def is_valid_command?(user_comm)
        return VALID_COMMAND_HASH[user_comm.upcase]
    end


end
