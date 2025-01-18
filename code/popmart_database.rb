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
    end

    # Needs to be given a string representing the brand name, a string 
    # representing the series name, and a double representing the price 
    # for a singular popmart set. Adds it to the popmart_sets table.
    def add_set_to_db(brand, series_name, price)
        begin
            @db.execute("INSERT INTO popmart_sets (brand, series_name, price) VALUES (?, ?, ?)", 
                        [brand, series_name, price])
        rescue SQLite3::ConstraintException => e
            raise StandardError.new "Set #{brand} #{series_name} already exists"
        end
    end
    
    # Needs to be given the brand name and series name for a popmart set.
    # Searches the popmart_sets table for the specified set and returns 
    # its row information in an array. If nothing is found, raise an 
    # exception to alert the user.
    def get_set_information(brand, series_name)
        result = @db.execute("SELECT * FROM popmart_sets WHERE brand = ? AND series_name = ?", 
                             [brand, series_name])

        if !(result.empty?)
            return result[0]
        else 
            raise StandardError.new "Set #{brand} #{series_name} does not exist in database"
        end
    end

    # Needs to be given the brand and series name of a set.
    # Deletes that set from the popmart_sets table.
    def delete_set_from_db(brand, series_name)
        begin
            get_set_information(brand, series_name)
            @db.execute("DELETE FROM popmart_sets WHERE brand = ? AND series_name = ?", 
                        [brand, series_name])
        rescue StandardError => e
            raise e
        end
    end
    
    # Takes in all the information needed to define one figure.
    # Adds it to the popmart_figures table in the database.
    # The brand and series name are their own parameters. The
    # rest of the figure's information is in the fig_info array
    # parameter.
    def add_fig_to_db(brand, series_name, fig_info)
        fig_name = fig_info[0]
        probability = fig_info[1]
        is_collected = fig_info[2] # This has to be 1 or 0, not true or false
        is_secret = fig_info[3] # This has to be 1 or 0, not true or false

        @db.execute("INSERT INTO popmart_figures (figure_name, probability, 
                    is_collected, is_secret, brand, series_name) 
                    VALUES (?, ?, ?, ?, ?, ?)", 
                    [fig_name, probability, is_collected, is_secret, brand, series_name])
    end
    
    # Takes in the name of a figure. Returns the corresponding
    # row from the popmart_figures database table.
    def get_fig_from_db(figure_name)
        result = @db.execute("SELECT * FROM popmart_figures WHERE figure_name = ?", [figure_name])

        if !(result.empty?)
           return result[0] 
        else
            raise StandardError.new "Figure #{figure_name} does not exist in database"
        end 
    end

    # Deletes the specified figure from the popmart_figure database table
    def delete_fig_from_db(figure_name)
        begin
            get_fig_from_db(figure_name)
            @db.execute("DELETE FROM popmart_figures WHERE figure_name = ?", [figure_name])
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
        @db.execute "DROP TABLE popmart_figures"
    end
end
