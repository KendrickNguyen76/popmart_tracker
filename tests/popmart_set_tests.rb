# popmart_set_tests.rb

# This file contains all of the tests for the PopMartSet class (and helper classes), 
# which is located in the popmart_set.rb file. This will be used to test the functionality 
# of the class and ensure that everything is working properly.

# Require Statements
require_relative "../code/popmart_set.rb"
require "test/unit"
require "stringio"

class TestPopMartFigure < Test::Unit::TestCase
    # TestPopMartFigure contains the test cases for the PopMartFigure class


    # Tests the PopMartFigure constructor w/o is_secret parameter
    def test_constructor_without_secret
        test_figure = PopMartFigure.new("Apple", 1/6, true)

        assert_equal(test_figure.name, "Apple")
        assert_equal(test_figure.probability, 1/6)
        assert_equal(test_figure.is_collected, true)
        assert_equal(test_figure.is_secret, false)
    end

    # Tests the PopMartFigure constructor w/ is_secret parameter
    def test_constructor_with_secret
        test_figure = PopMartFigure.new("Pumpkin King", 1/72, true, true)

        assert_equal(test_figure.is_secret, true)
    end

    # Tests == operator correctly returns true
    def test_equality_operator_returns_true
        test_figure = PopMartFigure.new("test", Float(1/8), false, true)
        test_figure2 = PopMartFigure.new("test", Float(1/8), false, true)

        assert_true(test_figure == test_figure2)
    end

    # Tests == operator correctly returns false
    def test_equality_operator_returns_false
        test_figure = PopMartFigure.new("test", 1/8, false, true)
        test_figure2 = PopMartFigure.new("test2", 1/8, false, true)
        test_figure3 = PopMartFigure.new("test", 0.25, false, true)
        test_figure4 = PopMartFigure.new("test", 1/8, true, true)
        test_figure5 = PopMartFigure.new("test", 1/8, false, false)

        assert_false(test_figure == test_figure2)
        assert_false(test_figure == test_figure3)
        assert_false(test_figure == test_figure4)
        assert_false(test_figure == test_figure5)
        assert_false(test_figure == "Hello")
    end

    def test_figure_to_s_returns_proper_result
        test_figure = PopMartFigure.new("test", 1/8, false, true)
        test_str = test_figure.to_s
        correct_result = "Name: test\nProbability: 0.0\nCollected: false\nSecret: true"

        assert_equal(test_str, correct_result)
    end
end



class TestPopMartSet < Test::Unit::TestCase
    # TestPopMartSet contains the test cases for the PopMartSet class


    # Tests the PopMartSet constructor without giving it a specific price
    def test_constructor_without_price
        test_set = PopMartSet.new("TestBrand", "TestSeries")

        assert_equal(test_set.brand, "TestBrand")
        assert_equal(test_set.series_name, "TestSeries")
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
        assert_equal(test_set.price, 22.0)

        test_set.change_price(-111)
        assert_equal(test_set.price, 22.0)
    end

    # Tests that a new PopMartSet object has no figures
    def test_new_set_had_no_figures
        test_set = PopMartSet.new("test", "test")
        assert_equal(test_set.num_of_figures, 0)
    end

    # Tests adding a PopMartFigure to a PopMartSet
    def test_adding_figures
        test_set = PopMartSet.new("test", "test")
        test_set.add_figure(PopMartFigure.new("Foo", 3/5, false))

        assert_equal(test_set.num_of_figures, 1)
    end
	
    # Tests that adding a duplicate figure raises an exception
    def test_adding_figures_raises_exception_when_figure_already_exists
        test_set = PopMartSet.new("test", "test")
        test_set.add_figure(PopMartFigure.new("Foo", 3/5, false))

        assert_raise_message("Figure Foo already exists in test test") {
            test_set.add_figure(PopMartFigure.new("Foo", 3/5, false))
        }
    end

    # Tests finding figures in a PopMartSet
    def test_finding_figures
        test_set = PopMartSet.new("test", "test")

        test_set.add_figure(PopMartFigure.new("Foo", 1/6, false, false))
        test_set.add_figure(PopMartFigure.new("Bar", 1/72, true, true))
        
        foo = test_set.find_figure("Foo")
        bar = test_set.find_figure("Bar")

        assert_equal(foo.name, "Foo")
        assert_equal(foo.probability, 1/6)
        assert_equal(foo.is_collected, false)
        assert_equal(foo.is_secret, false)

        assert_equal(bar.name, "Bar")
        assert_equal(bar.probability, 1/72)
        assert_equal(bar.is_collected, true)
        assert_equal(bar.is_secret, true)
    end
	
	# Tests that find_figure returns nil when a figure doesn't exist
    def test_finding_figures_returns_nil
        test_set = PopMartSet.new("returns", "nil")

        result = test_set.find_figure("non-existant")

        assert_equal(result, nil)
    end

    # Tests changing figure's collected status using PopMartSet
    def test_mark_figure_as_collected_changes_collected_status 
        test_set = PopMartSet.new("test", "test")
        test_set.add_figure(PopMartFigure.new("Foo", 1/6, false))

        test_set.mark_figure_as_collected("Foo")

        assert_equal(test_set.find_figure("Foo").is_collected, true)
    end
	
	# Tests that mark_figure_as_collected does throw exception
    def test_mark_figure_as_collected_throws_exception_when_figure_is_nonexistent
        test_set = PopMartSet.new("test", "test")
        
        assert_raise_message("Figure Bar does not exist within test test, cannot mark it as collected") {
            test_set.mark_figure_as_collected("Bar")
        }
    end
	
    # Tests that delete_figure correctly deletes the specified figure
    def test_delete_figure_deletes_correct_figure
        test_set = PopMartSet.new("test", "test")
        test_set.add_figure(PopMartFigure.new("Foo", 1/6, false))
        test_set.add_figure(PopMartFigure.new("Bar", 1/6, true))

        assert_equal(test_set.num_of_figures, 2)

        test_set.delete_figure("Foo")

        assert_equal(test_set.num_of_figures, 1)
        assert_true(test_set.find_figure("Foo").nil?)
    end

    # Tests that delete_figure does throw exception	
    def test_delete_figure_raises_error_if_figure_nonexistant
        test_set = PopMartSet.new("test", "test")

        assert_raise("Figure Bar does not exist in test test") {
            test_set.delete_figure("Bar")
        }
    end
    
    # Tests that to_s method returns a correct string representation
    def test_to_s_returns_correct_string
        test_set = PopMartSet.new("test", "test")
        correct_result = "Brand: test\nSeries: test\nNumber of Figures: 0\nPrice: 0.0 dollars"

        assert_equal(test_set.to_s, correct_result)
    end
    
    # Tests that print_figure_names prints "No figures" 
    # when there are no figures in the set
    def test_print_figure_names_prints_message_when_no_figures_are_present
        test_set = PopMartSet.new("test", "test")
        
        # All this does is set the standard output
        # to a string buffer that I can use for testing
        test_output = StringIO.new
        original_stdout = $stdout
        $stdout = test_output

        test_set.print_figure_names

        assert_equal(test_output.string, "No figures\n")

        $stdout = original_stdout
    end
    
    # Tests that print_figure_names functions properly when there are multiple
    # figures in a set
    def test_print_figure_names_prints_out_name_of_each_figure
        test_set = PopMartSet.new("test", "test") 
        test_set.add_figure(PopMartFigure.new("Foo", 1/6, false))
        test_set.add_figure(PopMartFigure.new("Bar", 1/6, true))

        # Set standard output to string buffer
        test_output = StringIO.new
        original_stdout = $stdout
        $stdout = test_output

        test_set.print_figure_names

        assert_equal(test_output.string, "Foo\nBar\n")

        $stdout = original_stdout
    end

end
