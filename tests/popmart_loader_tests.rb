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
    
    # Tests to see if the figures within a Popmart Set can be
    # properly loaded into and out of the database.
    def test_can_save_and_load_figures_from_database
        @test_loader.save_sets_into_db(@test_list)
        loaded_sets = @test_loader.load_sets_from_db

        3.times do |i|
            test_set_figs = @test_list[i].figures
            result_set_figs = loaded_sets[i].figures
            
            test_set_figs.zip(result_set_figs).each do |test_fig, result_fig|
                assert_equal(test_fig.name, result_fig.name)
                assert_equal(test_fig.probability, result_fig.probability)
                assert_equal(test_fig.is_collected, result_fig.is_collected)
                assert_equal(test_fig.is_secret, result_fig.is_secret)
            end
        end
    end

    # Tests that load_sets_from_db returns an empty list
    # when no sets are currently stored in the database
    def test_loading_empty_database_returns_empty_array
        empty_array = @test_loader.load_sets_from_db
        assert_true(empty_array.empty?)
    end

    # Tests that mark_figures_in_db correctly sets the collected 
    # status of the specified figures to "true"
    def test_mark_figures_in_db_changes_collected_status_to_true
        @test_loader.save_sets_into_db(@test_list)
        marked_fig_names = Array.new

        9.times do |n|
            fig_name = "fig_#{n}"
            if n % 2 == 0
                marked_fig_names.push(fig_name)
            end
        end

        @test_loader.mark_figures_in_db(marked_fig_names)
        loaded_sets = @test_loader.load_sets_from_db

        loaded_sets[0].figures.each do |fig|
            assert_true(fig.is_collected)
        end
    end
    
    # Tests that delete_set_in_db deletes all of 
    # the popmart sets given to it
    def test_delete_sets_in_db_correctly_deletes_all_sets
        @test_loader.save_sets_into_db(@test_list)
        @test_loader.delete_sets_in_db(@test_list)
        should_be_empty = @test_loader.load_sets_from_db

        assert_true(should_be_empty.empty?)

        begin
            # If the delete has worked, this line should
            # run without throwing any errors
            @test_loader.save_sets_into_db(@test_list)
        rescue StandardError
            assert_true(false)
        end
    end
    
    # Tests that delete_figs_in_db deletes all of the popmart
    # figures given to it from the database
    def test_delete_figs_in_db_correctly_deletes_specifed_figures
        deleted_fig_names = Array.new
        
        @test_list[0].figures.each do |figure|
            deleted_fig_names.push(figure.name)
        end
        
        @test_loader.save_sets_into_db(@test_list)
        @test_loader.delete_figs_in_db(deleted_fig_names)
        results = @test_loader.load_sets_from_db

        assert_true(results[0].figures.empty?)
    end

    # Tests that you can update the figures in a set
    # when calling save_sets_into_db if a figure
    # already exists in the database
    def test_updating_figures_for_a_set
        @test_loader.save_sets_into_db(@test_list)
        new_fig = PopMartFigure.new("updated_fig", 0.25, false, false)
        initial_load = @test_loader.load_sets_from_db
        assert_true(initial_load[2].figures.length == 0)

        @test_list[2].add_figure(new_fig)

        @test_loader.save_sets_into_db(@test_list)
        results = @test_loader.load_sets_from_db
        
        added_fig = results[2].figures[0]
        
        assert_true(results[2].figures.length > 0)
        assert_equal(added_fig.name, new_fig.name)
        assert_equal(added_fig.probability, new_fig.probability)
        assert_equal(added_fig.is_collected, new_fig.is_collected)
        assert_equal(added_fig.is_secret, new_fig.is_secret)
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
