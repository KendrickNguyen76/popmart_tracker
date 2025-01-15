# popmart_tracker.rb

# Run this file to run the program

# Require statements
require "./code/popmart_tracker_ui.rb"


# Main function, runs the popmart tracker by created
# a new PopTrackUI object.
def main
	program = PopTrackUI.new
    program.run_tracker
end

# Call the main function
main()
