# popmart_set.rb

# This file contains the PopMartSet class and any helper classes it might need. 

class PopMartFigure
    # PopMartFigure is a class that represents a singular Pop Mart figurine
    # that you would find in a blindbox

    # It has three instance variables:

    # @name - the name of the figurine
    # @probability - the probability of getting that figure
    # @is_secret - boolean value determining whether or not the figure is a secret
    attr_reader :name, :probability, :is_secret


    # The constructor for a PopMartFigure object
    def initialize(name, probability, is_secret = false)
        @name = name
        @probability = probability
        @is_secret = is_secret
    end
end



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
        @brand = brand
        @series_name = series_name
        @figures = Array.new
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

    
    def add_figure(f_name, f_prob, f_secret)

    def find_figure(f_name)

end