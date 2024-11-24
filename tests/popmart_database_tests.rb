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
        @test_handler.add_set_to_database("Foo", "Bar", 0.0)
        @test_handler.add_set_to_database("Perrin", "Aybara", 15.768)
        test_result_one = @test_handler.get_set_information("Foo", "Bar")
        test_result_two = @test_handler.get_set_information("Perrin", "Aybara")

        assert_equal(test_result_one, ["Foo", "Bar", 0.0])
        assert_equal(test_result_two, ["Perrin", "Aybara", 15.768])
    end

    # Tests adding duplicate sets to the database, should raise error
    def test_adding_duplicate_set
        @test_handler.add_set_to_database("Foo", "Bar", 0.0)

        assert_raise_message("Set Foo Bar already exists") {@test_handler.add_set_to_database("Foo", "Bar", 0.0)}
    end

    # Tests searching for a non-existent set in the database, should throw error
    def test_searching_for_nonexistent_set
        assert_raise_message("Set Does Not Exist does not exist in database") {@test_handler.get_set_information("Does Not", "Exist")}
    end

    # Tests deleting a specific row from the popmart_sets table
    def test_deleting_row_from_sets_table
        @test_handler.add_set_to_database("Foo", "Bar", 0.0)
        @test_handler.add_set_to_database("Book", "Store", 17.76)

        @test_handler.delete_specific_set("Foo", "Bar")

        assert_equal(@test_handler.get_set_information("Book", "Store"), ["Book", "Store", 17.76])
        assert_raise_message("Set Foo Bar does not exist in database") {@test_handler.get_set_information("Foo", "Bar")}
    end

    # Tests deleting nonexistent set from the database
    def test_deleting_nonexistant_set_raises_error
        assert_raise_message("Set Foo Bar does not exist in database") {@test_handler.delete_specific_set("Foo", "Bar")}
    end

    # When tests end, drop all tables in the test database and close the connection
    def teardown
        @test_handler.reset_database_for_testing_only()
        @test_handler.close_database()
    end
end