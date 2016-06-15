require_relative 'errors'
require 'pry'
class EconomicProfile
  attr_reader :economic_data_by_district, :name
  def initialize(economic_data)
    @economic_data_by_district = economic_data
    @name = @economic_data_by_district[:name]
  end

  def append_economic_data(conflicting_district)
    @economic_data_by_district.merge!(conflicting_district.economic_data_by_district)
  end

  def median_household_income_in_year(year)
    median_income = @economic_data_by_district[:median_household_income]
    covered_years = median_income.keys.find_all do |range|
      (range.first..range.last).cover?(year)
    end
    unless covered_years.flatten.empty?
      covered_years.reduce do |first_range, other_range|
        median_income[first_range] + median_income[other_range]
      end / covered_years.count
    else
      raise UnknownDataError, "Year not included in district income data."
    end
  end
end
