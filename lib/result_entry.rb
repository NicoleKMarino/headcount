require 'pry'

class ResultEntry
  attr_accessor :name
  def initialize(entries)
    @entries = entries
  end

  def free_and_reduced_price_lunch_rate
    @entries[:free_and_reduced_price_lunch_rate].round(3)
  end

  def children_in_poverty_rate
    @entries[:children_in_poverty_rate].round(3)
  end

  def high_school_graduation_rate
    @entries[:high_school_graduation_rate].round(3)
  end

  def median_household_income
    @entries[:median_household_income]
  end
end
