require_relative 'economic_profile_statistical_parser'
require_relative 'errors'
require 'pry'
class EconomicProfile
  attr_reader :economic_data_by_district, :name
  def initialize(economic_data)
    @economic_data_by_district = economic_data
    @name = @economic_data_by_district[:name]
    @profile_parser = EconomicProfileStatisticalParser.new
  end

  def append_economic_data(conflicting_district)
    @economic_data_by_district.merge!(conflicting_district.economic_data_by_district)
  end

  def median_household_income_in_year(year)
    median_income = @economic_data_by_district[:median_household_income]
    @profile_parser.find_matching_ranges(median_income, year)
  end

  def median_household_income_average
    median_incomes = @economic_data_by_district[:median_household_income].values
    median_incomes.reduce(:+) / median_incomes.count
  end

  def children_in_poverty_in_year(year)
    @profile_parser.find_children_in_poverty(@economic_data_by_district[:children_in_poverty], year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    @profile_parser.find_free_or_reduced_lunch_percentage(@economic_data_by_district[:free_or_reduced_price_lunch], year)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    @profile_parser.find_free_or_reduced_lunch_number(@economic_data_by_district[:free_or_reduced_price_lunch], year)
  end

  def title_i_in_year(year)
    @profile_parser.find_title_i_in_year(@economic_data_by_district[:title_i], year)
  end
end
