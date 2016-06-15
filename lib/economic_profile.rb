require_relative 'economic_profile_statistical_parser'
require_relative 'errors'
require 'pry'
class EconomicProfile
  attr_reader :economic_data, :name
  def initialize(economic_data)
    @economic_data = economic_data
    @name = @economic_data[:name]
    @profile_parser = EconomicProfileStatisticalParser.new
  end

  def append_economic_data(conflicting_district)
    @economic_data.merge!(conflicting_district.economic_data)
  end

  def median_household_income_in_year(year)
    median_income = @economic_data[:median_household_income]
    @profile_parser.find_matching_ranges(median_income, year)
  end

  def median_household_income_average
    median_incomes = @economic_data[:median_household_income].values
    median_incomes.reduce(:+) / median_incomes.count
  end

  def children_in_poverty_in_year(year)
    @profile_parser.find_children(@economic_data[:children_in_poverty], year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    lunch_percentage = @economic_data[:free_or_reduced_price_lunch]
    @profile_parser.find_lunch_percentage(lunch_percentage, year)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    lunch_number = @economic_data[:free_or_reduced_price_lunch]
    @profile_parser.find_lunch_number(lunch_number, year)
  end

  def title_i_in_year(year)
    @profile_parser.find_title_i_in_year(@economic_data[:title_i], year)
  end
end
