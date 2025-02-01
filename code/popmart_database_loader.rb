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
            # Will need functionality later for loading
            # figures from each set into database
        end
    end

    # Loads in all sets from the database. Stores and returns
    # it as a dictionary to be used in the program.
    def load_sets_from_db
        all_sets = @db_handler.get_all_sets
        return convert_to_set_obj(all_sets)
    end


    private
    
    # Takes in a list of lists. Each list represents
    # a row from the popmart_sets table. Converts them
    # into a list of PopMartSet objects.
    def convert_to_set_obj(set_list)
        popmart_set_list = Array.new

        set_list.each do |set|
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
            is_collected = (fig.is_collected ? 1 : 0)
            is_secret = (fig.is_secret ? 1 : 0)
        
            fig_info = [fig.name, fig.probability, 
                        is_collected, is_secret]
            @db_handler.add_fig_to_db(the_brand, the_series, fig_info)
        end
    end
end
