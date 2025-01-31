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
        @test_loader = PopMartDBLoader.new("test2.db")
        @test_list = create_popmart_set_list
    end
    
    # Tests that the db_path instance variable is correctly 
    # defined when given a value for it
    def test_can_initialize_by_providing_db_path_string
        assert_equal("test2.db", @test_loader.db_path)
    end
    
    # Tests that the db_path instance variable is correctly defined
    # when not given a value for it. In this case, it should use
    # the provided default value in the class definition
    def test_can_initialize_with_default_db_path
        default_loader = PopMartDBLoader.new
        assert_false(default_loader.db_path.nil?)
        File.delete(default_loader.db_path)
    end
    
    # Tests that you can save sets into and load sets from
    # the database through the loader
    def test_can_save_and_load_sets_from_database
        @test_loader.save_sets_into_db(@test_list)
        sets_loaded_from_db = @test_loader.load_sets_from_db

        assert_equal(sets_loaded_from_db.length, @test_list.length)
        3.times do |i|
            assert_equal(@test_list[i].to_s, sets_loaded_from_db[i].to_s)
        end
    end

    def teardown
        # Clears out the test2.db file before performing another test
        File.write("test2.db", "")
    end

    
    private

    # Creates the list of PopMartSets used for testing
    def create_popmart_set_list
        set_list = Array.new

        3.times do |n|
           new_set = PopMartSet.new("brand_#{n}", "series_#{n}", n.to_f)
           set_list.push(new_set)
        end

        return set_list
    end
end
