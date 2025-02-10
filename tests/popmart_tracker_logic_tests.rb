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
end

