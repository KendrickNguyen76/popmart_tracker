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
            if set_exists?(popmart_set)
                update_set_figures(popmart_set)
            else
                add_new_set_to_db(popmart_set)
            end
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

    # Takes in the brand and series name of a popmart set.
    # Loads all of the figures in fig_list into the database
    # w/ the brand and series name as foreign keys
    def save_figures_into_db(the_brand, the_series, fig_list)
        fig_list.each do |fig|
            is_collected = bool_to_int(fig.is_collected)
            is_secret = bool_to_int(fig.is_secret)
        
            fig_info = [fig.name, fig.probability, 
                        is_collected, is_secret]
            @db_handler.add_fig_to_db(the_brand, the_series, fig_info)
        end
    end
    
    # Takes in a list of strings where each string is the name 
    # of a figure who has been marked as collected. Changes the 
    # corresponding column in the database to reflect this change.
    def mark_figures_in_db(marked_fig_names)
        marked_fig_names.each do |marked_fig|
            @db_handler.mark_fig_in_db(marked_fig)
        end
    end

    # Takes in a list of popmart set objects.
    # Deletes all of them from the database
    def delete_sets_in_db(to_be_deleted_sets)
        to_be_deleted_sets.each do |deleted_set|
            @db_handler.delete_set_from_db(deleted_set.brand,
                                           deleted_set.series_name)
        end
    end

    # Takes in a list of popmart figure names
    # Deletes all of them from the database
    def delete_figs_in_db(deleted_fig_names)
        deleted_fig_names.each do |deleted_fig|
            @db_handler.delete_fig_from_db(deleted_fig)
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

    # Adds in a completely new set to the database
    def add_new_set_to_db(popmart_set)
        @db_handler.add_set_to_db(popmart_set.brand, popmart_set.series_name,
                                  popmart_set.price)
        save_figures_into_db(popmart_set.brand,popmart_set.series_name,
                             popmart_set.figures)
    end
    
    # Checks to see if the given set has new figures.
    # If it does, add them into the database.
    def update_set_figures(set)
        new_figs = Array.new

        set.figures.each do |fig|
            if !figure_exists?(fig)
                new_figs.push(fig)
            end
        end

        save_figures_into_db(set.brand, set.series_name, new_figs)
    end

    # Checks to see if a given popmart set already
    # exists within the database. 
    def set_exists?(set)
        begin
            @db_handler.get_set_information(set.brand, set.series_name)
            return true
        rescue StandardError
            return false
        end
    end

    # Checks to see if the given popmart figure
    # already exists within the database.
    def figure_exists?(figure)
        begin
            @db_handler.get_fig_from_db(figure.name)
            return true
        rescue StandardError
            return false
        end
    end
end
