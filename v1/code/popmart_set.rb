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
    attr_accessor :price
    attr_reader :brand, :series_name, :figures


    # The constructor for a PopMartSet object
    def initialize(brand, series_name, price = 0.0)
        @brand = brand.upcase
        @series_name = series_name.upcase
        @price = price
    end

end