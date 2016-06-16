module ResultFormatter

  def find_poverty_and_hs_grad
    @result_set = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last if @state == nil
    @dr.districts.each do |name, district|
      format_poverty_and_hs_graduation(district) if lunch?(district)
    end
  end

  def find_income_disparity
    @result_set = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last if @state == nil
    @dr.districts.each do |name, district|
      format_income_disparity(district) if median_income?(district)
    end
  end

  def lunch?(district)
    graduation?(district) if lunch_avg(district) > state_lunch_avg
  end

  def graduation?(district)
    poverty_check?(district) if grad_avg(district) > state_grad_avg
  end

  def median_income?(district)
    poverty_check?(district) if median_income(district) > state_median_income
  end

  def poverty_check?(district)
    poverty_avg(district) > state_poverty_avg
  end

  def poverty_avg(district)
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

  def grad_avg(district)
    grad = district.enrollment.enrollment_data[:high_school_graduation]
    calculate_average(grad)
  end

  def state_grad_avg
    state_graduation = @state.enrollment.enrollment_data[:high_school_graduation]
    calculate_average(state_graduation)
  end
  

  def lunch_avg(district)
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

  def median_income(district)
    income = district.economic_profile.economic_data[:median_household_income]
    calculate_average(income)
  end

  def state_median_income
    income = @state.economic_profile.economic_data[:median_household_income]
    calculate_average(income)
  end

  def append_matching_districts(result)
    @result_set.matching_districts << result
  end

  def format_high_poverty_and_hs_graduation(district)
    result = ResultEntry.new({:free_and_reduced_price_lunch_rate => lunch_avg(district),
                     :children_in_poverty_rate => poverty_avg(district),
                     :high_school_graduation_rate => grad_avg(district)})
    result.name = district.name
    append_matching_districts(result)
    add_statewide_high_poverty_and_hs_graduation
  end

  def add_statewide_high_poverty_and_hs_graduation
    statewide = ResultEntry.new({:free_and_reduced_price_lunch_rate => state_lunch_avg,
                                 :children_in_poverty_rate => state_poverty_avg,
                                 :high_school_graduation_rate => state_grad_avg})
    @result_set.statewide_average = statewide
  end

  def format_income_disparity(district)
    result = ResultEntry.new({:children_in_poverty_rate => poverty_avg(district),
                              :median_household_income => median_income(district)})
    result.name = district.name
    append_matching_districts(result)
    add_statewide_income_disparity
  end

  def add_statewide_income_disparity
    statewide = ResultEntry.new({:children_in_poverty_rate => state_poverty_avg,
                              :median_household_income => state_median_income})
    @result_set.statewide_average = statewide
    binding.pry
  end

end
