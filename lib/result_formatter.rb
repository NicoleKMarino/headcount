module ResultFormatter

  def find_matching_districts
    @result_set = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last
    @dr.districts.each do |name, district|
      format_entry(district) if poverty_check?(district)
    end
  end
  
  def format_entry(district)
    result = ResultEntry.new({:free_and_reduced_price_lunch_rate => district_lunch_avg(district),
                     :children_in_poverty_rate => district_poverty_avg(district),
                     :high_school_graduation_rate => district_grad_avg(district)})
    result.name = district.name
    append_matching_districts(result)
  end

  def poverty_check?(district)
    graduation?(district) if district_poverty_avg(district) > state_poverty_avg
  end

  def graduation?(district)
    lunch?(district) if district_grad_avg(district) > state_grad_avg
  end

  def lunch?(district)
    district_lunch_avg(district) > state_lunch_avg
  end

  def household_income?(district)
    binding.pry
    household_income(district) > household_income(@state) unless district.economic_profile.economic_data[:median_household_income] == nil
  end

  def district_poverty_avg(district)
    pov_children = district.economic_profile.economic_data[:children_in_poverty]
    unless pov_children == nil
      calculate_average(pov_children)
    end
  end
  
  def calculate_average(district_data)
    district_data.values.reduce(:+) / district_data.count
  end

  def state_poverty_avg
    eligible_districts = @dr.districts.find_all do |district|
      district.last.economic_profile.economic_data[:children_in_poverty] != nil
    end.to_h
    calculate_state_poverty(eligible_districts)
  end

  def calculate_state_poverty(eligible_districts)
    unless eligible_districts.flatten.empty?
      eligible_districts.reduce(0) do |sum, district|
        poverty = district.last.economic_profile.economic_data[:children_in_poverty]
        sum + (calculate_average(poverty))
      end / eligible_districts.count
    end
  end

  def district_grad_avg(district)
    grad = district.enrollment.enrollment_data[:high_school_graduation]
    calculate_average(grad)
  end

  def state_grad_avg
    state_graduation = @state.enrollment.enrollment_data[:high_school_graduation]
    calculate_average(state_graduation)
  end
  

  def district_lunch_avg(district)
    lunch = district.economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    calculate_free_lunch(lunch)
  end
  
  def state_lunch_avg
    lunch = @state.economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    calculate_free_lunch(lunch)
  end

  def calculate_free_lunch(lunch_data)
    lunch_data.values.reduce(0) do |result, lunch|
      result + lunch[:percentage]
    end / lunch_data.count
  end

  def append_matching_districts(result)
    @result_set.matching_districts << result
    add_statewide_data
  end

  def add_statewide_data
    statewide = ResultEntry.new({:free_and_reduced_price_lunch_rate => state_lunch_avg,
                                 :children_in_poverty_rate => state_poverty_avg,
                                 :high_school_graduation_rate => state_grad_avg})
    @result_set.statewide_average = statewide
  end
end
