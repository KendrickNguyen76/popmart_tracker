# popmart_database.rb

# This file contains the PopMartDatabaseHandler class

# Require Statements
require "sqlite3"

class PopMartDatabaseHandler
    # PopMartDatabaseHanlder is a class that is responsible for facilitating
    # database transactions such as creating tables, inserting information into
    # the database, and taking information out of it. It is connected to an SQLite
    # database through the use of the sqlite3 gem.

    # It has one instance variable:

    # @db - represents the connection to the database that this class will interact with

    # The constructor for a PopMartDatabaseHandler. Needs a string
    # representing the file path to the database.
    def initialize(database_path)
        @db = SQLite3::Database.new database_path
        create_tables()
    end

    # Creates the tables that the program will need: popmart_sets and popmart_figures
    def create_tables
        @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS popmart_sets (
                brand TEXT,
                series_name TEXT,
                price REAL,
                PRIMARY KEY (brand, series_name)
            ) STRICT;
        SQL
        
        # We'll come back to the figures table later
        """
        @db.execute <<-SQL
            CREATE TABLE IF NOT EXISTS popmart_figures (
                figure_name TEXT PRIMARY KEY,
                probability REAL,
                is_collected INTEGER,
                is_secret INTEGER,
                brand TEXT,
                series_name TEXT,
                FOREIGN KEY (brand, series_name) REFERENCES popmart_sets (brand, series_name)
            ) STRICT;
        SQL
        """
    end

    # Needs to be given a string representing the brand name, a string representing 
    # the series name, and a double representing the price for a singular popmart set.
    # Adds it to the popmart_sets table in the database.
    def add_set_to_database(brand, series_name, price)
        begin
            @db.execute "INSERT INTO popmart_sets (brand, series_name, price) VALUES (?, ?, ?)", [brand, series_name, price]
        rescue SQLite3::ConstraintException => e
            raise StandardError.new "Set #{brand} #{series_name} already exists"
        end
    end
    
    # Needs to be given the brand name and series name for a popmart set. Searches the 
    # popmart_sets table for the specified set and returns its row information in an array.
    # If nothing is found, raise an exception to alert the user.
    def get_set_information(brand, series_name)
        result = @db.execute "SELECT * FROM popmart_sets WHERE brand = ? AND series_name = ?", [brand, series_name]
        if !result.empty?
            return result[0]
        else 
            raise StandardError.new "Set #{brand} #{series_name} does not exist in database"
        end
    end
    
    # Note to self, give this a better name
    # Also add some documentation
    def delete_specific_set(brand, series_name)
        begin
            get_set_information(brand, series_name)
            @db.execute "DELETE FROM popmart_sets WHERE brand = ? AND series_name = ?", [brand, series_name]
        rescue StandardError => e
            raise e
        end
    end

    # Closes the connection to the database.
    def close_database
        @db.close
    end

    # FOR TESTING ONLY, DO NOT USE IN THE ACTUAL PROGRAM
    # Drops all tables in the database.
    def reset_database_for_testing_only
        @db.execute "DROP TABLE popmart_sets"
    end
end
