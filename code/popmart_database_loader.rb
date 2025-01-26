# popmart_database_loader.rb

# This file contains the PopMartDBLoader class

# Require Statements
require_relative "popmart_database.rb"

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
    # it as a dictionary to be used in the program
    def load_sets_from_db
        # nothing here yet!  
    end
end
