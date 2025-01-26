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

    # @db_path - represents the connection to the database that this
    #            class will interact with through PopMartDatabaseHandler
    # DB_PATH_DEFAULT - A constant default value for @db_path

    attr_reader :db_path

    DB_PATH_DEFAULT = "placeholder.db"
    

    # Constructor for a PopMartDBLoader object.
    def initialize(provided_db=DB_PATH_DEFAULT)
       @db_path = provided_db
       @db_handler = PopMartDatabaseHandler.new(@db_path)
    end
    
    # Loads in all sets from the database. Stores and returns
    # it as a dictionary to be used in the program.
    def load_sets_from_db
        all_sets = @db_handler.get_all_sets
        
    end


    private
    
    # Takes in a list of lists. Each list represents
    # a row from the popmart_sets table. Converts them
    # into a list of PopMartSet objects.
    def convert_to_set_obj(set_list)
        popmart_set_list = Array.new

        set_list.each do |set|
            new_set_obj = PopMartSet.new(set_list[0], set_list[1],
                                         set_list[2])
            popmart_set_list.append(new_set_obj)
        end

        return popmart_set_list
    end
end
