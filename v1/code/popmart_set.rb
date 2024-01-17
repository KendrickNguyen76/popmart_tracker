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

    # Returns the number of figures in the set
    def num_of_figures
        return @figures.size
    end

    # Requires a string representing the figure name, a number representing the
    # probability of getting the figure, and a boolean representing whether
    # the figure is a secret figure. Constructs a PopMartFigure object and
    # adds it to the @figure instance variable
    def add_figure(f_name, f_prob, f_secret)
        @figures.push(PopMartFigure.new(f_name, f_prob, f_secret))
    end

    # Requires a string that represents the name of the figure the user wants to find
    # If it exists, return it. Otherwise, return nil.
    def find_figure(f_name)
        @figures.each do |figure|
            if (figure.name == f_name)
                return figure
            end
        end
    end

end