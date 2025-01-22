# popmart_database_loader.rb

# This file contains the PopMartDBLoader class

# Require Statements
require_relative "popmart_database.rb"

class PopMartDBLoader
    attr_reader :db_path

    DB_PATH_DEFAULT = "placeholder"

    def initialize(provided_db=DB_PATH_DEFAULT)
       @db_path = provided_db 
    end
end
