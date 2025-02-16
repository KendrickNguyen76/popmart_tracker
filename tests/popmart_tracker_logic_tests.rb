# popmart_tracker_logic_tests.rb

# This file contains all of the tests for the PopTrackLogic class, which is contained in
# the popmart_tracker_logic.rb file. This will be used to make sure the class is working
# properly and that there are no glaring bugs/issues.

# Require statements
require_relative "../code/popmart_tracker_logic.rb"
require_relative "../code/popmart_set.rb"
require "test/unit"

class TestPopTrackLogic < Test::Unit::TestCase
    # TestPopTrackLogic contains the test cases for the PopTrackLogic class
	
	
    # Create a PopTrackLogic object called test_tracker before each test.
    def setup
        @test_tracker = PopTrackLogic.new("test3.db")
        @test_set = PopMartSet.new("Brand", "Series Name")
    end

    # Tests that generate_dict_key returns the correct result
    def test_generate_dict_key_creates_key_in_correct_format
        test_key = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)

        assert_equal(test_key, "BRAND_SERIES NAME")
    end

    # Tests that add_set() allows you to add a set to PopTrackLogic
    def test_can_add_pop_mart_set_objects_to_class
        assert_equal(@test_tracker.sets.size, 0)
        
        @test_tracker.add_set(@test_set)

        assert_equal(@test_tracker.sets.size, 1)
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].brand, "Brand")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].series_name, "Series Name")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].price, 0.0)
    end
	
    # Tests that add_to_specific_set() allows you to 
    # add a figure to a specific set
    def test_can_add_pop_mart_figure_to_specific_set
        test_figure = PopMartFigure.new("name", 1/2, true)

        @test_tracker.add_set(@test_set)
        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        find_result = @test_tracker.sets["BRAND_SERIES NAME"].find_figure(test_figure.name)

        assert_equal(find_result.name, test_figure.name)
    end

    # Tests that get_set() correctly returns correct set
    def test_get_set_returns_set_when_found
        @test_tracker.add_set(@test_set)

        get_result = @test_tracker.get_set("brand", "series name")

        assert_equal(get_result.brand, @test_set.brand)
        assert_equal(get_result.series_name, @test_set.series_name)
    end

    # Tests that get_set() throws an ArgumentError when given
    # a test that doesn't exist in PopTrackLogic
    def test_get_set_throws_argument_error_when_set_not_found
        assert_raise_message("Set with name Exist and brand Doesnt does not exist") {
            @test_tracker.get_set("Doesnt", "Exist")
        }
    end
    
    # Tests that mark_figure_in_specified_set correctly marks 
    # the specified figure as collected.
    def test_mark_figure_in_specified_set_marks_figure_as_collected 
        test_figure = PopMartFigure.new("name", 1/2, false)

        @test_tracker.add_set(@test_set)
        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        @test_tracker.mark_figure_in_specified_set("BRAND_SERIES NAME", test_figure.name)
        find_result = @test_tracker.sets["BRAND_SERIES NAME"].find_figure(test_figure.name)

        assert_true(find_result.is_collected)
    end

    def test_delete_figure_in_specified_set_correctly_deletes_figure 
        test_figure = PopMartFigure.new("name", 1/2, false)

        @test_tracker.add_set(@test_set)
        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        @test_tracker.delete_figure_in_specified_set("BRAND_SERIES NAME", test_figure.name)
        find_result = @test_tracker.sets["BRAND_SERIES NAME"].find_figure(test_figure.name)

        assert_nil(find_result)
    end
    
    # Tests to see if delete_set() can delete the specified test
    def test_delete_set_deletes_correct_set
        @test_tracker.add_set(@test_set)
        @test_tracker.delete_set("brand", "series name")

        assert_equal(0, @test_tracker.sets.length)
        assert_raise(ArgumentError.new "Set with name series name and brand brand does not exist") {@test_tracker.get_set("brand", "series name")}
    end
    
    # Tests to see if delete_set() raises an error when trying to 
    # delete a set that does not exist within @test_tracker
    def test_delete_set_raises_error_when_set_does_not_exist
        assert_raise_message("Set with name Exist and brand Doesnt does not exist") {
            @test_tracker.delete_set("Doesnt", "Exist")
        }
    end
    
    # Tests that add_set_using_params correctly adds a set
    def test_can_add_pop_mart_set_objects_to_class_using_params
        assert_equal(@test_tracker.sets.size, 0)

        @test_tracker.add_set_using_params("Brand", "Series Name", 0.0)

        assert_equal(@test_tracker.sets.size, 1)
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].brand, "Brand")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].series_name, "Series Name")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].price, 0.0)
    end
    
    # Tests that the @changes hash has been intialized properly
    def test_changes_is_initialized_properly
        assert_true(@test_tracker.changes[:marked_figures].empty?)
        assert_true(@test_tracker.changes[:deleted_figures].empty?)
        assert_true(@test_tracker.changes[:deleted_sets].empty?)
    end
    
    # Tests that you can load and save sets between the tracker
    # and its associated database. Also tests that figures within
    # a set are also properly loaded and saved
    def test_loading_and_saving_sets_from_tracker_to_database
        @test_tracker.add_set(@test_set)
        test_figure = PopMartFigure.new("name", 1/2, true)
        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        @test_tracker.save_sets

        @test_tracker.delete_set(@test_set.brand, @test_set.series_name)
        @test_tracker.reload_sets

        assert_true(@test_tracker.sets.length > 0)
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].brand, "Brand")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].series_name, "Series Name")
        assert_equal(@test_tracker.sets["BRAND_SERIES NAME"].price, 0.0)
        
        find_result = @test_tracker.sets["BRAND_SERIES NAME"].find_figure(test_figure.name)
        assert_equal(find_result.name, test_figure.name)
    end
    
    # Tests that the tracker can update the database to reflect
    # which figures have been marked as collected
    def test_marking_figures_in_database_from_tracker
        @test_tracker.add_set(@test_set)

        test_figure = PopMartFigure.new("name", 1/2, false)
        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        added_figure = @test_tracker.get_set(@test_set.brand, @test_set.series_name).find_figure("name")

        assert_false(added_figure.is_collected)

        set_name = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)
        @test_tracker.mark_figure_in_specified_set(set_name, test_figure.name)

        assert_false(@test_tracker.changes[:marked_figures].empty?)

        @test_tracker.save_sets
        @test_tracker.reload_sets
        
        reloaded_fig = @test_tracker.get_set(@test_set.brand, @test_set.series_name).find_figure("name")
        
        assert_true(reloaded_fig.is_collected)
        assert_true(@test_tracker.changes[:marked_figures].empty?)
    end

    # Tests that @changes[:marked_figures] is added to and cleared properly
    def test_changes_marked_figures_gets_cleared_when_saving
        @test_tracker.add_set(@test_set)
        test_figure = PopMartFigure.new("name", 1/2, false)

        @test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
        set_name = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)
        @test_tracker.mark_figure_in_specified_set(set_name, test_figure.name)

        assert_false(@test_tracker.changes[:marked_figures].empty?)

        @test_tracker.save_sets
        @test_tracker.reload_sets
        
        assert_true(@test_tracker.changes[:marked_figures].empty?)
    end
    
    # Tests that you can delete sets in the database from the tracker class
    def test_deleting_sets_in_database_from_tracker
        @test_tracker.add_set(@test_set)
        @test_tracker.save_sets
        @test_tracker.reload_sets

        assert_true(@test_tracker.sets.values.length > 0)

        @test_tracker.delete_set(@test_set.brand, @test_set.series_name)
        @test_tracker.save_sets
        @test_tracker.reload_sets

        assert_false(@test_tracker.sets.values.length > 0)
        assert_raise_message("Set with name Series Name and brand Brand does not exist") {
            @test_tracker.get_set(@test_set.brand, @test_set.series_name)
        }
    end
    
    # Tests that @changes[:deleted_sets] is cleared and added to properly
    def test_changes_deleted_sets_is_cleared_when_saving
        @test_tracker.add_set(@test_set)
        @test_tracker.save_sets
        @test_tracker.delete_set(@test_set.brand, @test_set.series_name)
        
        assert_true(@test_tracker.changes[:deleted_sets].length > 0)

        @test_tracker.save_sets
        @test_tracker.reload_sets

        assert_false(@test_tracker.changes[:deleted_sets].length > 0)
    end

    # This test reveals that there is a major bug in my current delete process
    # It occurs when a set is newly added and hasn't been saved to the database yet.
    # When I delete that set from @sets, it succeeds w/o problem, and adds the set
    # to @changes[:deleted_sets]. However, this becomes a problem when I call save_sets
    # The set i am trying to delete no longer exists in @sets, so it doesn't get saved.
    # Therefore, the function freaks out since I am trying to delete a nonexistent set from
    # the database. This test should verify that the bug has been fixed.
    def test_newly_added_sets_that_are_then_deleted_get_ignored_during_save
        @test_tracker.add_set(@test_set)
        @test_tracker.delete_set(@test_set.brand, @test_set.series_name)
        
        begin
            @test_tracker.save_sets
        rescue StandardError => e
            puts e.message
            assert_true(false)
        end
    end
    
    # Tests that you can delete figures in the database from the tracker class
    def test_deleting_figures_in_database_from_tracker
        @test_tracker.add_set(@test_set)
        set_key = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)
        test_figure = PopMartFigure.new("name", 1/2, false)
        @test_tracker.add_to_specific_set(set_key, test_figure)

        @test_tracker.save_sets
        @test_tracker.reload_sets

        assert_true(@test_tracker.sets.values[0].figures.length > 0)

        @test_tracker.delete_figure_in_specified_set(set_key, test_figure.name)
        @test_tracker.save_sets
        @test_tracker.reload_sets

        assert_false(@test_tracker.sets.values[0].figures.length > 0)
        assert_raise_message("Figure name does not exist in Brand Series Name") {
            @test_tracker.delete_figure_in_specified_set(set_key, test_figure.name)
        }
    end
    
    # Tests that @changes[:delete_figures] is cleared and added to properly
    def test_changes_deleted_figures_is_updated_when_saving
        @test_tracker.add_set(@test_set)
        set_key = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)
        test_figure = PopMartFigure.new("name", 1/2, false)
        @test_tracker.add_to_specific_set(set_key, test_figure)
        @test_tracker.save_sets
        @test_tracker.reload_sets
        @test_tracker.delete_figure_in_specified_set(set_key, test_figure.name)

        assert_true(@test_tracker.changes[:deleted_figures].length > 0)

        @test_tracker.save_sets
        @test_tracker.reload_sets
        
        assert_false(@test_tracker.changes[:deleted_figures].length > 0)
    end
   
    # Tests to see if deleting figures has the same bug as deleting sets
    def test_newly_added_figures_that_are_then_deleted_get_ignored_when_saving
        @test_tracker.add_set(@test_set)
        set_key = @test_tracker.generate_dict_key(@test_set.brand, @test_set.series_name)
        test_figure = PopMartFigure.new("name", 1/2, false)
        @test_tracker.add_to_specific_set(set_key, test_figure)
        @test_tracker.delete_figure_in_specified_set(set_key, test_figure.name)
        
        begin
            @test_tracker.save_sets
        rescue StandardError => e
            puts e.message
            assert_true(false)
        end
    end

    def teardown
        File.delete("test3.db")
    end
end

