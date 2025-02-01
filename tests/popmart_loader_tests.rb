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
        create_popmart_figures 
    end
    
    # A test for the setup method. Just want to make sure
    # that it works before I write more complex tests.
    def test_setup_creates_sets_and_figs_correctly
        assert_equal(@test_list.length, 3)
        assert_equal(@test_list[0].figures.length, 5)
        assert_equal(@test_list[1].figures.length, 4)
        assert_equal(@test_list[2].figures.length, 0)
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
    
    # This test is temporarily broken since not all functionality is up yet!
    # Tests that you can save sets into and load sets from
    # the database through the loader
    #def test_can_save_and_load_sets_from_database
        #@test_loader.save_sets_into_db(@test_list)
        #sets_loaded_from_db = @test_loader.load_sets_from_db

        #assert_equal(sets_loaded_from_db.length, @test_list.length)
        #3.times do |i|
            #assert_equal(@test_list[i].to_s, sets_loaded_from_db[i].to_s)
        #end
    #end

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

    # Creates PopMartFigures used for testing.
    def create_popmart_figures
        9.times do |n|
            collected = (Random.rand(2) > 0 ? true : false)
            secret = (Random.rand(2) > 0 ? true : false)

            new_fig = PopMartFigure.new("fig_#{n}", n.to_f, collected, secret)

            pick_set_to_add_to(new_fig, n)
        end
    end

    # Adds PopMartFigure to a specific set 
    # in @test_list depending on value of n
    def pick_set_to_add_to(fig, n)
        if n % 2 == 0
            @test_list[0].add_figure(fig) 
        else
            @test_list[1].add_figure(fig) 
        end
    end

end
