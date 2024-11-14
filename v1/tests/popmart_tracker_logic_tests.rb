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


    # Tests that is_valid_command() returns true or false correctly depending on its input
    def test_is_valid_command_returns_correct_value
        test_tracker = PopTrackLogic.new

        assert_true(test_tracker.is_valid_command?("add set"));
        assert_true(test_tracker.is_valid_command?("ADD SET"));
        assert_false(test_tracker.is_valid_command?("invalid"));
    end

    # Tests that add_set() allows you to add a set to PopTrackLogic
    def test_can_add_pop_mart_set_objects_to_class
        test_tracker = PopTrackLogic.new
        
        assert_equal(test_tracker.sets.size, 0)
        
        test_tracker.add_set(PopMartSet.new("Brand", "Series Name"))

        assert_equal(test_tracker.sets.size, 1)
        assert_equal(test_tracker.sets["BRAND_SERIES NAME"].brand, "Brand")
        assert_equal(test_tracker.sets["BRAND_SERIES NAME"].series_name, "Series Name")
        assert_equal(test_tracker.sets["BRAND_SERIES NAME"].price, 0.0)
    end
	
	# Tests that add_to_specific_set() allows you to add a figure to
	# a specific set
	def test_can_add_pop_mart_figure_to_specific_set
		test_tracker = PopTrackLogic.new
		test_set = PopMartSet.new("Brand", "Series Name")
		test_figure = PopMartFigure.new("name", 1/2, true)

		test_tracker.add_set(test_set)
		test_tracker.add_to_specific_set("BRAND_SERIES NAME", test_figure)
		find_result = test_tracker.sets["BRAND_SERIES NAME"].find_figure(test_figure.name)
		
		assert_equal(find_result.name, test_figure.name)
	end
end

