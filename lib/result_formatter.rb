module ResultFormatter

  def find_poverty_and_hs_grad
    @rs = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last if @state == nil
    @dr.districts.each do |name, district|
      format_high_poverty_and_hs_graduation(district) if lunch?(district)
    end
  end

  def find_income_disparity
    @rs = ResultSet.new({:matching_districts => [], :statewide_average => nil})
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
    @rs.matching_districts << result
  end

  def format_high_poverty_and_hs_graduation(district)
    r = ResultEntry.new({:free_and_reduced_price_lunch_rate => lunch_avg(district),
                     :children_in_poverty_rate => poverty_avg(district),
                     :high_school_graduation_rate => grad_avg(district)})
    r.name = district.name
    append_matching_districts(r)
    add_statewide_high_poverty_and_hs_graduation
  end

  def add_statewide_high_poverty_and_hs_graduation
    st = ResultEntry.new({:free_and_reduced_price_lunch_rate => state_lunch_avg,
                                 :children_in_poverty_rate => state_poverty_avg,
                                 :high_school_graduation_rate => state_grad_avg})
    @rs.statewide_average = st
  end

  def format_income_disparity(district)
    r = ResultEntry.new({:children_in_poverty_rate => poverty_avg(district),
                              :median_household_income => median_income(district)})
    r.name = district.name
    append_matching_districts(r)
    add_statewide_income_disparity
  end

  def add_statewide_income_disparity
    st = ResultEntry.new({:children_in_poverty_rate => state_poverty_avg,
                              :median_household_income => state_median_income})
    @rs.statewide_average = st
  end

   def high_poverty_and_high_school_graduation
     find_poverty_and_hs_grad
   end

   def high_income_disparity
     find_income_disparity
   end

   def kindergarten_participation_against_household_income(district)
     @state = @dr.districts.shift.last if @state == nil
     kindergarten_variation(district) / median_income_variation(district)
   end

   def median_income_variation(district)
     median_income(@dr.find_by_name(district)).to_f / state_median_income.to_f
   end

   def kindergarten_variation(district)
     unless district == nil
       d_kin = @dr.find_by_name(district).enrollment.enrollment_data[:kindergarten_participation]
       s_kin = @state.enrollment.enrollment_data[:kindergarten_participation]
       calculate_average(d_kin) / calculate_average(s_kin)
     end
   end

   def kindergarten_participation_correlates_with_household_income(district)
     kp_and_hh_income_correlation_across_districts(district) if district.keys.include?(:across)
     district = district[:for]
     statewide_income_correlation if district == "STATEWIDE"
     if (0.6..1.5).cover?(kindergarten_participation_against_household_income(district))
       true
     end
   end

   def kp_and_hh_income_correlation_across_districts(district)
     districts = district[:across]
     correlated_districts = districts.reduce([]) do |result, district|
       result << kindergarten_participation_correlates_with_household_income({:for => district})
     end
     if correlated_districts.compact!.empty?
       false
     else
       find_correlation_districts(correlated_districts)
     end
   end

   def find_correlation_districts(correlated_districts)
     correlated_districts.all?{|val|val == true}
   end

   def statewide_income_correlation
     @state = @dr.districts.shift.last if @state == nil
     correlated = 0
     @dr.districts.each do |name, district|
       if kindergarten_participation_correlates_with_household_income({:for => district.name})
         correlated += 1
       end
     end
     correlation_check?(correlated)
   end

   def correlation_check?(correlated)
     true if correlated > (@dr.districts.count * 0.7)
   end
end
