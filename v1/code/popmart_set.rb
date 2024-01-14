# popmart_set.rb

# This file contains the PopMartSet class. It is used to represent a singular popmart
# set, and will be utilized in many different parts of the program overall.

class PopMartSet
    # PopMartSet is a class that represents a singular Pop Mart set of blindboxes

    # It has three instance variables:

    # @brand - the brand/character of the set (ex. DIMOO, SkullPanda, etc.)
    # @series - the series of the set (ex. Vacation, Valentines Day, etc.)
    # @price - the price of the set in total
    # @figures - an array of all the figures in the Popmart set
    attr_reader :brand, :series_name, :price, :figures


    # The constructor for a PopMartSet object
    def initialize(brand, series_name, price = 0.0)
        @brand = brand.upcase
        @series_name = series_name.upcase
        change_price(price)
    end

    # Requires one parameter that should be a number greater than 0.0
    # If either of these conditions is false, then don't change the price
    def change_price(new_price)
        if ((new_price.is_a?(Numeric)) && new_price >= 0.0)
            @price = new_price
        elsif (@price.nil?)
            @price = 0.0
        end
    end

end