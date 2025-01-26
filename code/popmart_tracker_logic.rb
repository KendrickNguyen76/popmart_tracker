# popmart_tracker_logic.rb

# Contains the logic/backend portion of the the popmart tracker application.
# This functionality will be contained in the PopTrackLogic class.

# Require statements
require_relative "popmart_set.rb"


class PopTrackLogic
    # PopTrackLogic is a class that is used for handling the logical portions of the
    # Popmart Tracker application. This includes tasks such as writing to files, 
    # checking user commands, returning information that the uswer wants to look at, etc.

    # It has two instance variables:

    # @file_path - the path of the file that PopTrackLogic will interact with
    # @sets - a hash containing all of the Popmart Sets that the user wants to store
    #         * The keys will be the brand name + the series name of the Popmart set
    #         * The values will be PopMartSet objects
    attr_reader :sets


    # The constructor for the PopTrackLogic class
    def initialize
        @sets = Hash.new
    end
	
    # Generates a set's dictionary key. This is in the format of BRAND_SERIESNAME
    def generate_dict_key(brand, series_name)
        return (brand + "_" + series_name).upcase
    end

    # Needs to be given a PopMartSet object. Adds it to the @sets hash.
    def add_set(popmart_set)
        key = generate_dict_key(popmart_set.brand, popmart_set.series_name)
        @sets[key] = popmart_set
    end
    
    # Needs to be given the brand, series name, and probability.
    # Creates a PopMartSet object and adds it to the @sets hash.
     

	# Needs to be given a name of a Popmart set, and a PopMartFigure object.
	# Adds the object to the set with the specified name.
    def add_to_specific_set(set_name, popmart_figure)
        @sets[set_name].add_figure(popmart_figure)
    end
    
    # Needs to be given the name of a Popmart set and a PopMartFigure object.
    # Marks the figure within the specified set as collected
    def mark_figure_in_specified_set(set_name, figure_name)
        @sets[set_name].mark_figure_as_collected(figure_name)
    end
    
    # Needs to be given the name of a Popmart set and a PopMartFigure object.
    # Deletes the figure within the specified set.
    def delete_figure_in_specified_set(set_name, figure_name)
        @sets[set_name].delete_figure(figure_name)
    end

    # Needs to be given the name and brand of a set. Checks to see if it
    # exists in @sets. If it does, return it, if not raise an error.
    def get_set(brand_name, series_name)
        key = generate_dict_key(brand_name, series_name)
        if @sets.has_key?(key)
            return @sets[key]
        else
            raise ArgumentError.new "Set with name #{series_name} and brand #{brand_name} does not exist"
        end
    end
    
    # Needs to be given the name and brand of set. Deletes the set if
    # it exists in @sets. Raise an error if it doesn't
    def delete_set(brand_name, series_name)
        key = generate_dict_key(brand_name, series_name)
        
        @sets.delete(key) do
            raise ArgumentError.new "Set with name #{series_name} and brand #{brand_name} does not exist"
        end
    end

end

# Notes:
    # Need to connect this to popmart_database.rb
    # - Save all the sets that get added to @sets
    # - Then at end of program, save them all to the database, should
    #   hopefully be more efficient in terms of file read/write time
    # - Or, save them all when the user specifies that they want to
    #   save things. More responsibility for the user, but less work
    #   for me (LMAO)
    # - Only really call the database when the user needs to get a set
    #   that is not already in @sets
    # - Only other question is how do I test all of this functionality?
    # - Probably gonna be a hassle regardless (ugh)

    # Need to develop a UI for this program
    # - Maybe jump straight into Tkinter? Not sure if that's wise
    # - Probably best if i got all of the the kinks worked out in
    #   this class first before I even do any of that. 
