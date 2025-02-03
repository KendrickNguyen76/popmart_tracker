# popmart_database_loader.rb

# This file contains the PopMartDBLoader class

# Require Statements
require_relative "popmart_database.rb"
require_relative "popmart_set.rb"

class PopMartDBLoader
    # PopMartDBLoader is a class that is responsible for loading
    # and storing informtion to and from PopMartDatabaseHandler
    # and PopTrackLogic. It acts as a middleman essentially.

    # It has one instance variable and one constant:

    # @db_path - Represents the connection to the database that this
    #            class will interact with through PopMartDatabaseHandler
    # @db_handler - The PopMartDatabaseHandler that will be used to
    #               access information from the database
    # DB_PATH_DEFAULT - A constant default value for @db_path

    attr_reader :db_path

    DB_PATH_DEFAULT = "placeholder.db"
    

    # Constructor for a PopMartDBLoader object.
    def initialize(provided_db=DB_PATH_DEFAULT)
       @db_path = provided_db
       @db_handler = PopMartDatabaseHandler.new(@db_path)
    end
    
    # Saves a list of PopMartSet objects into 
    # the database using @db_handler. 
    def save_sets_into_db(popmart_set_list)
        popmart_set_list.each do |popmart_set|
            @db_handler.add_set_to_db(popmart_set.brand, 
                                      popmart_set.series_name,
                                      popmart_set.price)

            save_figures_into_db(popmart_set)
        end
    end

    # Loads in all sets from the database. Stores and returns
    # it as a dictionary to be used in the program.
    def load_sets_from_db
        begin
            all_sets = @db_handler.get_all_sets
            popmart_sets = convert_to_set_obj(all_sets)

            popmart_sets.each do |set|
                insert_figs_from_db(set)
            end

            return popmart_sets
        rescue StandardError
            return Array.new
        end
    end


    private
    
    # Takes in a list of lists. Each list represents
    # a row from the popmart_sets table. Converts them
    # into a list of PopMartSet objects.
    def convert_to_set_obj(set_rows)
        popmart_set_list = Array.new

        set_rows.each do |set|
            new_set_obj = PopMartSet.new(set[0], set[1], set[2])
            popmart_set_list.append(new_set_obj)
        end

        return popmart_set_list
    end

    # Takes in a PopMartSet. Loads all of its
    # figures into the database
    def save_figures_into_db(popmart_set)
        the_brand = popmart_set.brand
        the_series = popmart_set.series_name

        popmart_set.figures.each do |fig|
            is_collected = bool_to_int(fig.is_collected)
            is_secret = bool_to_int(fig.is_secret)
        
            fig_info = [fig.name, fig.probability, 
                        is_collected, is_secret]
            @db_handler.add_fig_to_db(the_brand, the_series, fig_info)
        end
    end

    # Requires a PopMartFigure object that is currently
    # empty (has no figures). Loads it with the corresponding
    # figures from the database
    def insert_figs_from_db(set) # Add error handling for this one too
        begin
            all_figs = @db_handler.get_fig_for_specific_set(set.brand, set.series_name)
        rescue StandardError
            all_figs = Array.new
        end

        all_figs.each do |fig_arr|
            new_fig = PopMartFigure.new(fig_arr[0], fig_arr[1], 
                                       int_to_bool(fig_arr[2]), 
                                       int_to_bool(fig_arr[3]))
            set.add_figure(new_fig) 
        end
    end

    # Takes in an boolean value. If it is true, 
    # return 1. If it is false, return 0.
    def bool_to_int(bool)
        return (bool ? 1 : 0)
    end
    
    # Takes in an integer that is 0 or 1.
    # If it is 1, return true. If it is 0,
    # return false.
    def int_to_bool(integer)
        return integer == 1
    end
end
