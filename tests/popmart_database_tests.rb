# popmart_database_tests.rb

# This file contains all of the tests for the PopMartDataBaseHandler class 
# which is located in the popmart_database.rb file. This will be used to test 
# if the class can correctly handle database interactions.

# Require Statements
require_relative "../code/popmart_database.rb"
require "test/unit"


class TestPopMartDatabse < Test::Unit::TestCase
    # TestPopMartDatabase contains the test cases for the PopMartDatabaseHandler class


    # Setup the test cases by creating an instanse variable that contains a
    # PopMartDatabaseHandler object
    def setup
        @test_handler = PopMartDatabaseHandler.new("test.db")
    end

    # Tests adding popmart sets to the database
    def test_adding_set_to_database
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)
        @test_handler.add_set_to_db("Perrin", "Aybara", 15.768)
        test_result_one = @test_handler.get_set_information("Foo", "Bar")
        test_result_two = @test_handler.get_set_information("Perrin", "Aybara")

        assert_equal(test_result_one, ["Foo", "Bar", 0.0])
        assert_equal(test_result_two, ["Perrin", "Aybara", 15.768])
    end

    # Tests adding duplicate sets to the database, should raise error
    def test_adding_duplicate_set
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)

        assert_raise_message("Set Foo Bar already exists") {
            @test_handler.add_set_to_db("Foo", "Bar", 0.0)
        }
    end

    # Tests searching for a non-existent set in the database, should throw error
    def test_searching_for_nonexistent_set
        assert_raise_message("Set Does Not Exist does not exist in database") {
            @test_handler.get_set_information("Does Not", "Exist")
        }
    end

    # Tests deleting a specific row from the popmart_sets table
    def test_deleting_row_from_sets_table
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)
        @test_handler.add_set_to_db("Book", "Store", 17.76)

        @test_handler.delete_set_from_db("Foo", "Bar")

        assert_equal(@test_handler.get_set_information("Book", "Store"), ["Book", "Store", 17.76])
        assert_raise_message("Set Foo Bar does not exist in database") {
            @test_handler.get_set_information("Foo", "Bar")
        }
    end

    # Tests deleting nonexistent set from the database
    def test_deleting_nonexistant_set_raises_error
        assert_raise_message("Set Foo Bar does not exist in database") {
            @test_handler.delete_set_from_db("Foo", "Bar")
        }
    end
    
    # Tests adding popmart figures to the database
    def test_adding_figures_to_database
        fig_info_one = ["fig_name", 0.25, 0, 0]
        fig_info_two = ["fig_name2", 0.5, 0, 1]
        @test_handler.add_fig_to_db("Foo", "Bar", fig_info_one)
        @test_handler.add_fig_to_db("Perrin", "Aybara", fig_info_two)
        test_result_one = @test_handler.get_fig_from_db("fig_name")
        test_result_two = @test_handler.get_fig_from_db("fig_name2")

        assert_equal(test_result_one, ["fig_name", 0.25, 0, 0, "Foo", "Bar"]) 
        assert_equal(test_result_two, ["fig_name2", 0.5, 0, 1, "Perrin", "Aybara"])
    end
    
    # Tests searching for figure that does not exist in the database
    def test_searching_for_nonexistent_figures
        assert_raise_message("Figure DoesNotExist does not exist in database") {
            @test_handler.get_fig_from_db("DoesNotExist")
        }
    end
    
    # Test deleting a specific row from the popmart_figures table
    def test_deleting_row_from_popmart_figures
        fig_info_one = ["fig_name", 0.25, 0, 0]
        fig_info_two = ["fig_name2", 0.5, 0, 1]
        @test_handler.add_fig_to_db("Foo", "Bar", fig_info_one)
        @test_handler.add_fig_to_db("Perrin", "Aybara", fig_info_two)

        test_result_one = @test_handler.get_fig_from_db("fig_name")
        assert_equal(test_result_one, ["fig_name", 0.25, 0, 0, "Foo", "Bar"]) 
        
        @test_handler.delete_fig_from_db("fig_name2")
        assert_raise_message("Figure fig_name2 does not exist in database") {
            @test_handler.get_fig_from_db("fig_name2")
        }
    end

    # Tests deleting nonexistent figure from the database
    def test_deleting_nonexistant_figure_raises_error
        assert_raise_message("Figure Foo does not exist in database") {
            @test_handler.delete_fig_from_db("Foo")
        }
    end
    
    # Tests that the is_collected column of a specified row can be change
    def test_mark_figure_as_collected_in_database        
        fig_info_one = ["fig_name", 0.25, 0, 0]
        @test_handler.add_fig_to_db("Foo", "Bar", fig_info_one) 
        fig_info_two = ["fig_name2", 0.5, 1, 1]
        @test_handler.add_fig_to_db("Perrin", "Aybara", fig_info_two)

        @test_handler.mark_fig_in_db("fig_name")
        @test_handler.mark_fig_in_db("fig_name2")
        
        test_result_one = @test_handler.get_fig_from_db("fig_name")
        assert_equal(test_result_one, ["fig_name", 0.25, 1, 0, "Foo", "Bar"])  
        test_result_two = @test_handler.get_fig_from_db("fig_name2")
        assert_equal(test_result_two, ["fig_name2", 0.5, 1, 1, "Perrin", "Aybara"])
    end
    
    # Tests that the get_all_sets method works properly
    def test_get_all_sets_correctly_returns_all_sets
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)
        @test_handler.add_set_to_db("Perrin", "Aybara", 15.768)
        
        test_get_all_sets = @test_handler.get_all_sets

        assert_true(test_get_all_sets.length == 2)
        assert_equal(test_get_all_sets[0], ["Foo", "Bar", 0.0])
        assert_equal(test_get_all_sets[1], ["Perrin", "Aybara", 15.768])
    end

    # Tests that the get_all_sets method throws an error 
    # when there are no sets in the database
    def test_get_all_sets_throws_error_when_database_empty
        assert_raise_message("No sets stored in database") {
            @test_handler.get_all_sets
        }
    end
    
    # Tests that get_fig_from_db returns a list of all rows in
    # popmart_figures that have foreign keys that match the 
    # specified parameters.
    def test_get_fig_for_specific_set_returns_all_figures_in_given_set
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)
        fig_info_one = ["fig_name", 0.25, 0, 0]
        @test_handler.add_fig_to_db("Foo", "Bar", fig_info_one) 
        fig_info_two = ["fig_name2", 0.5, 1, 1]
        @test_handler.add_fig_to_db("Foo", "Bar", fig_info_two)

        test_result = @test_handler.get_fig_for_specific_set("Foo", "Bar")

        assert_equal(test_result[0], ["fig_name", 0.25, 0, 0, "Foo", "Bar"]) 
        assert_equal(test_result[1], ["fig_name2", 0.5, 1, 1, "Foo", "Bar"])
    end
    
    # Tests that get_fig_for_specific_set raises an error when the
    # specified set has no figures. Should work for figures that do
    # and don't exist in the database.
    def test_get_fig_for_specifc_set_raises_error_when_no_figures
        @test_handler.add_set_to_db("Foo", "Bar", 0.0)

        assert_raise_message("Set Foo Bar has no figures in database") {
            @test_handler.get_fig_for_specific_set("Foo", "Bar")
        }

        assert_raise_message("Set Heh Heh has no figures in database") {
            @test_handler.get_fig_for_specific_set("Heh", "Heh")
        }
    end

    # When tests end, drop all tables in the test database and close the connection
    def teardown
        @test_handler.reset_database_for_testing_only()
        @test_handler.close_database()
    end
end
