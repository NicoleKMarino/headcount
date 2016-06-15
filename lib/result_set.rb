require 'pry'
require_relative 'result_entry'

class ResultSet
  attr_reader :matching_districts, :statewide_average
  def initialize(appropriate_districts)
    @matching_districts = appropriate_districts[:matching_districts]
    @statewide_average = appropriate_districts[:statewide_average]
  end

  
  def find_matching_districts
    @districts.each do |name, district|
      format_entry(district) if poverty_check?(district)
    end
  end
  
  def format_entry(district)
    result = ResultEntry.new({:free_and_reduced_price_lunch => district_lunch_avg(district),
                     :children_in_poverty => district_poverty_avg(district),
                     :high_school_graduation_rate => district_grad_avg(district)}
    append_matching_districts(result)
  end

  def append_matching_districts(result)
    matching_districts << result
  end

  def pov_check?(district)
    graduation?(district) if district_poverty_avg(district) > state_poverty_avg
  end

  def graduation?(district)
    lunch?(district) if district_grad_avg(district) > state_grad_avg
  end

  def lunch?(district)
    district_lunch_avg(district) > state_lunch_avg
  end

  def district_poverty_avg(district)
    pov_children = district.economic_profile.economic_data[:children_in_poverty]
    pov_children.values.reduce(:+) / pov.count
  end

  def state_poverty_avg
    eligible_districts = @districts.find_all do |district|
      district.last.economic_profile.economic_data[:children_in_poverty] == nil
    end.to_h
    calculate_state_poverty(eligible_districts)
  end

  def calculate_state_poverty(eligible_districts)
    eligible_districts.reduce(0) do |sum, district|
      poverty = district.last.economic_profile.economic_data[:children_in_poverty]
      sum + (poverty.values.reduce(:+) / poverty.count)
    end / var.count
  end

  def district_grad_avg(district_data)
    grad = district_data.enrollment.enrollment_data[:high_school_graduation]
    grad.values.reduce(:+) / grad.count
  end

  def state_grad_avg
    state_graduation = @districts["Colorado"].enrollment.enrollment_data[:high_school_graduation]
    state_graduation.values.reduce(:+) / state_graduation.count
  end
  

  def district_lunch_avg(district)
    lunch = district.economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    lunch.values.reduce(0) do |result, lunch|
      result + lunch[:total]
    end / lunch.count
  end
  
  def state_lunch_avg
    lunch = @districts["Colorado"].economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    lunch.values.reduce(0) do |result, lunch|
      result + lunch[:total]
    end / lunch.count
  end

end
