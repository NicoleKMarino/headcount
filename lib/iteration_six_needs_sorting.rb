
  def find_matching_districts
    @state = @districts.shift.last
    @districts.each do |name, district|
      format_entry(district) if poverty_check?(district)
    end
  end
  
  def format_entry(district)
    result = ResultEntry.new({:free_and_reduced_price_lunch => district_lunch_avg(district),
                     :children_in_poverty => district_poverty_avg(district),
                     :high_school_graduation_rate => district_grad_avg(district)})
    binding.pry
  end

  def append_matching_districts(result)
    matching_districts << result
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

  def district_poverty_avg(district)
    pov_children = district.economic_profile.economic_data[:children_in_poverty]
    unless pov_children == nil
      pov_children.values.reduce(:+) / pov_children.count
    end
  end

  def state_poverty_avg
    eligible_districts = @districts.find_all do |district|
      district.last.economic_profile.economic_data[:children_in_poverty] != nil
    end.to_h
    calculate_state_poverty(eligible_districts)
  end

  def calculate_state_poverty(eligible_districts)
    unless eligible_districts.flatten.empty?
      eligible_districts.reduce(0) do |sum, district|
        poverty = district.last.economic_profile.economic_data[:children_in_poverty]
        sum + (poverty.values.reduce(:+) / poverty.count)
      end / eligible_districts.count
    end
  end

  def district_grad_avg(district_data)
    grad = district_data.enrollment.enrollment_data[:high_school_graduation]
    grad.values.reduce(:+) / grad.count
  end

  def state_grad_avg
    state_graduation = @state.enrollment.enrollment_data[:high_school_graduation]
    state_graduation.values.reduce(:+) / state_graduation.count
  end
  

  def district_lunch_avg(district)
    lunch = district.economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    lunch.values.reduce(0) do |result, lunch|
      result + lunch[:total]
    end / lunch.count
  end
  
  def state_lunch_avg
    lunch = @state.economic_profile.economic_data[:eligible_for_free_or_reduced_lunch]
    lunch.values.reduce(0) do |result, lunch|
      result + lunch[:total]
    end / lunch.count / 180
  end


