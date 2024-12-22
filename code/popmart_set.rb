# popmart_set.rb

# This file contains the PopMartSet class and any helper classes it might need. 


class PopMartFigure
    # PopMartFigure is a class that represents a singular Pop Mart figurine
    # that you would find in a blindbox

    # It has four instance variables:

    # @name - the name of the figurine
    # @probability - the probability of getting that figure
    # @is_collected - boolean value determining whether or not the user has the figure
    # @is_secret - boolean value determining whether or not the figure is a secret
    attr_reader :name, :probability, :is_secret
    attr_accessor :is_collected

    # The constructor for a PopMartFigure object
    def initialize(name, probability, is_collected, is_secret = false)
        @name = name
        @probability = probability.to_f
        @is_collected = is_collected
        @is_secret = is_secret
    end

	# Equality operator. Two PopMartFigure objects are 
	# the same if all instance variables are equal.
	def ==(other)
		return (self.class == other.class &&
			self.name == other.name &&
			self.probability == other.probability &&
			self.is_collected == other.is_collected &&
			self.is_secret == other.is_secret)
	end
end



class PopMartSet
    # PopMartSet is a class that represents a singular Pop Mart set of blindboxes

    # It has four instance variables:

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
        if ((new_price.is_a?(Numeric)) && new_price > 0.0)
            @price = new_price
        elsif @price.nil?
            @price = 0.0
        end
    end

    # Returns the number of figures in the set
    def num_of_figures
        return @figures.size
    end
	
    # Requires a PopMartFigure object. Adds it to the @figures array
    def add_figure(figure)
		figure_check = find_figure(figure.name)
		
		case figure_check.nil?
		when true
        	@figures.push(figure)
		else
			raise StandardError.new "Figure #{figure.name} already exists in #{@brand} #{@series_name}"	
		end
    end

	# Takes in the name of a figure. If the figure exists in the set,
	# delete it. If not, raise an error.
	def delete_figure(figure_name)
		figure_check = find_figure(figure_name)

		if !(figure_check.nil?)
			# Delete the figure here	
		else
			raise StandardError.new "Figure #{figure_name} does not exist in #{@brand} #{@series_name}"
		end
	end

    # Requires a string that represents the name of the figure the user wants to find
    # If it exists, return it. Otherwise, return nil.
    def find_figure(f_name)
        @figures.each do |figure|
            if (figure.name == f_name)
                return figure
            end
        end

        return nil
    end

    # Requires a string that represents the name of the figure the user wants to change
    # the collected status of. If the figure exists then change its @is_collected instance
    # variable to true. If not, raise an Exception.
    def mark_figure_as_collected(f_name)
        collected_figure = find_figure(f_name)

		case collected_figure.nil?
		when false
			# For testing --> Print out name of figure being found & figure object itself
            # puts f_name
            # puts collected_figure
            collected_figure.is_collected = true
        else 
            raise StandardError.new "Figure #{f_name} does not exist within #{@brand} #{@series_name}"
        end
    end
	
end
