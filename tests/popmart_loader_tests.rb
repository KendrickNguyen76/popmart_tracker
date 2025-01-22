# popmart_loader_tests.rb


# This file contains all of the tests for the PopMartDBLoader class 
# which is located in the popmart_database_loader.rb file. This will 
# be used to test if the class can correctly handle loading and saving
# information to and from the program.

# Require Statements
require_relative "../code/popmart_database_loader.rb"
require "test/unit"


class TestPopMartDBLoader < Test::Unit::TestCase
    # TestPopMartDBLoader contains all of the tests cases for the
    # PopMartDBLoader class


    # Setup the test cases by creating an instanse variable that
    # contains a PopMartDBLoader object
    def setup
        @test_loader = PopMartDBLoader.new("test.db")
    end
    
    # Tests that the db_path instance variable is correctly 
    # defined when given a value for it
    def test_can_initialize_by_providing_db_path_string
        assert_equal("test.db", @test_loader.db_path)
    end
    
    # Tests that the db_path instance variable is correctly defined
    # when not given a value for it. In this case, it should use
    # the provided default value in the class definition
    def test_can_initialize_with_default_db_path
        default_loader = PopMartDBLoader.new
        assert_false(default_loader.db_path.nil?)
    end

end
