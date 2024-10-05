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
        test_result_one = @test_handler.get_set_information("Foo", "Bar")

        assert_equal(test_result_one, ["Foo", "Bar", 0.0])
    end

    # When tests end, drop all tables in the test database and close the connection
    def teardown
        @test_handler.reset_database_for_testing_only()
        @test_handler.close_database()
    end
end