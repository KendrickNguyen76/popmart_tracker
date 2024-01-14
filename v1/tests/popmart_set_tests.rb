# popmart_set_tests.rb

# This file contains all of the tests for the PopMartSet class, which is located
# in the popmart_set.rb file. This will be used to test the functionality of the class
# and ensure that everything is working properly.

# Require Statements
require_relative "../code/popmart_set.rb"
require "test/unit"

class TestPopMartSet < Test::Unit::TestCase
    # TestPopMartSet contains the test cases for the PopMartSet class


    # Tests the PopMartSet constructor without giving it a specific price
    def test_constructor_without_price
        test_set = PopMartSet.new("TestBrand", "TestSeries")

        assert_equal(test_set.brand, "TESTBRAND")
        assert_equal(test_set.series_name, "TESTSERIES")
    end

end