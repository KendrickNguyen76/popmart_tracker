# popmart_tracker_logic.rb

# Contains the logic/backend portion of the the popmart tracker application.
# This functionality will be contained in the PopTrackLogic class.

# Require statements
require_relative "popmart_set.rb"
require_relative "popmart_database_loader.rb"


class PopTrackLogic
    # PopTrackLogic is a class that is used for handling the logical portions of the
    # Popmart Tracker application. This includes tasks such as writing to files, 
    # checking user commands, returning information that the uswer wants to look at, etc.

    # It has two instance variables:

    # @file_path - the path of the file that PopTrackLogic will interact with
    # @sets - a hash containing all of the Popmart Sets that the user wants to store
    #         * The keys will be the brand name + the series name of the Popmart set
    #         * The values will be PopMartSet objects
    # @changes - a hash containing all of the changes the user has made so far
    #            * Each key corresponds to a type of change (Adding, deleting, etc.)
    #            * Each value will be a list of objects that have been changes
    #            * Use this hash to update the database
    # @db_loader - a PopMartDBLoader object that will handle database transactions
    attr_reader :sets, :changes


    # The constructor for the PopTrackLogic class
    def initialize(database_path="")
        @db_loader = initialize_loader(database_path)
        @sets = load_sets
        @changes = initialize_changes
    end
    
    # Updates the database to reflect all of the recent changes made.
    def save_sets
        @db_loader.save_sets_into_db(@sets.values)
        update_db_collected_status
        update_db_deleted_sets
        update_db_deleted_figures
    end

    # Updates @sets so that it matches the current state of the database
    def reload_sets
        @sets = load_sets
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
    def add_set_using_params(brand, series_name, price)
        key = generate_dict_key(brand, series_name)
        @sets[key] = PopMartSet.new(brand, series_name, price)
    end

    # Needs to be given a name of a Popmart set, and a PopMartFigure object.
    # Adds the object to the set with the specified name.
    def add_to_specific_set(set_name, popmart_figure)
        @sets[set_name].add_figure(popmart_figure)
    end

    # Needs to be given a name of a Popmart set, and an array that
    # contains all of the information to build a Popmart figure.
    # Creates a popmart figure object, and adds it the set with
    # the specified name
    def add_fig_using_params(set_name, fig_info)
        new_fig = PopMartFigure.new(fig_info[0], fig_info[1], 
                                    fig_info[2], fig_info[3])
        add_to_specific_set(set_name, new_fig)
    end
    
    # Needs to be given the name of a Popmart set and a PopMartFigure object.
    # Marks the figure within the specified set as collected
    def mark_figure_in_specified_set(set_name, figure_name)
        @sets[set_name].mark_figure_as_collected(figure_name)
        @changes[:marked_figures].push(figure_name)
    end
    
    # Needs to be given the name of a Popmart set and a PopMartFigure object.
    # Deletes the figure within the specified set.
    def delete_figure_in_specified_set(set_name, figure_name)
        @sets[set_name].delete_figure(figure_name)
        @changes[:deleted_figures].push(figure_name)
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
        
        if @sets.has_key?(key)
            @changes[:deleted_sets].push(@sets[key])
            @sets.delete(key)
        else
            raise ArgumentError.new "Set with name #{series_name} and brand #{brand_name} does not exist"
        end
    end


    private

    # Initializes @db_loader based on the value given to it
    def initialize_loader(db_path)
        if db_path.empty?
            return PopMartDBLoader.new
        else
            return PopMartDBLoader.new(db_path)
        end
    end

    # Initialize the @changes hash
    def initialize_changes
        changes = Hash.new
        
        changes[:marked_figures] = Array.new
        changes[:deleted_figures] = Array.new
        changes[:deleted_sets] = Array.new

        return changes
    end

    # Load sets from the database, and returns it as a hash. 
    # The keys are strings formatted in the manner described in
    # generate_dict_key, and the values are PopMartSet objects.
    def load_sets
        sets_hash = Hash.new
        sets_from_db = @db_loader.load_sets_from_db

        if !(sets_from_db.empty?)
            sets_from_db.each do |set|
               key = generate_dict_key(set.brand, set.series_name)
               sets_hash[key] = set
            end
        end

        return sets_hash
    end

    # Iterates through changes[:marked_figures], and updates
    # all of their corresponding rows in the database so that
    # they are marked as collected.
    def update_db_collected_status
        @db_loader.mark_figures_in_db(@changes[:marked_figures])
        @changes[:marked_figures].clear
    end
    
    # Iterates through changes[:deleted_sets], and updates 
    # the database so that every listed set gets removed.
    def update_db_deleted_sets
        @db_loader.delete_sets_in_db(@changes[:deleted_sets])
        @changes[:deleted_sets].clear
    end
    
    # Iterates through changes[:deleted_figures], and updates
    # the database so that every listed figure gets removed
    def update_db_deleted_figures
        @db_loader.delete_figs_in_db(@changes[:deleted_figures])
        @changes[:deleted_figures].clear
    end
end
