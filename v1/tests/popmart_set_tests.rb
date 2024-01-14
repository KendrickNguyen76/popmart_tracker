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
        assert_equal(test_set.price, 0.0)
    end

    # Tests the PopMartSet constructor when given a valid specific price
    def test_constructor_with_valid_price
        test_set = PopMartSet.new("test", "test", 2.0)
        test_set_two = PopMartSet.new("test", "test", 17)

        assert_equal(test_set.price, 2.0)
        assert_equal(test_set_two.price, 17)
    end

    # Tests the PopMartSet constructor when given an invalid specific price
    def test_constructor_with_invalid_price
        test_set = PopMartSet.new("test", "test", -22)
        test_set_two = PopMartSet.new("test", "test", "hi")

        assert_equal(test_set.price, 0.0)
        assert_equal(test_set_two.price, 0.0)
    end

    # Tests the change_price() method
    def test_change_price_outside_of_constructor
        test_set = PopMartSet.new("test", "test")

        test_set.change_price(22.0)
        assert_equal(test_set.price, 22.0);

        test_set.change_price(-111)
        assert_equal(test_set.price, 22.0);
    end

end