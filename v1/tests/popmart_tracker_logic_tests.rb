# popmart_tracker_logic_tests.rb

# This file contains all of the tests for the PopTrackLogic class, which is contained in
# the popmart_tracker_logic.rb file. This will be used to make sure the class is working
# properly and that there are no glaring bugs/issues.

# Require statements
require_relative "../code/popmart_tracker_logic.rb"
require "test/unit"

class TestPopTrackLogic < Test::Unit::TestCase
    def test_is_valid_command_returns_correct_value
        test_tracker = PopTrackLogic.new("Test/Path")

        assert_true(test_tracker.is_valid_command?("add"));
        assert_true(test_tracker.is_valid_command?("ADD"));
        assert_false(test_tracker.is_valid_command?("invalid"));
    end
end