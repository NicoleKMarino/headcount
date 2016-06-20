require 'pry'
module ResultFormatter
  def kindergarten_participation_rate_variation(district, competing_district)
    district_avg = kindergarten_variation(district)
    if competing_district[:against] == "COLORADO"
      competing_avg = kindergarten_variation("Colorado")
    else
      competing_avg = kindergarten_variation(competing_district[:against])
    end
    district_avg / competing_avg
  end

  def kindergarten_participation_rate_variation_trend(district_name1,district_name2)
    district1 =@dr.find_by_name(district_name1)
    district2 =@dr.find_by_name(district_name2)
    percents1 = district1.enrollment.enrollment_data[:kindergarten]
    percents2= district2.enrollment.enrollment_data[:kindergarten]
    merge_results(percents1,percents2)
  end

  def merge_results(percents1,percents2)
    result = percents1.merge(percents2){|k, a_value, b_value| a_value/b_value }
    answer= result.each do |k, v|
      result[k] = truncate_float(v)
    end
    answer
  end

  def truncate_float(float)
    unless float == nil
      (float * 1000).floor / 1000.to_f
    end
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder = kindergarten_variation(district)
    grad = grad_avg(@dr.find_by_name(district)) / state_grad_avg
    kinder / grad 
  end

  def kinder_grad_correlation_confirmation(kinder_grad_correlation)
    if (0.6..1.5).cover?(kinder_grad_correlation)
      true
    else
      false
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    if district == {:for => "STATEWIDE"}
      statewide_correlation_check
    elsif district.is_a?(Hash) && district[:across].is_a?(Array)
      subset_correlation_check(district)
    else
      single_district_correlation_check(district[:for])
    end
  end

  def single_district_correlation_check(district)
    if kindergarten_variation(district)
      kinder_ptcptn_vs_hs_grad = kindergarten_participation_against_high_school_graduation(district)
      kinder_grad_correlation_confirmation(kinder_ptcptn_vs_hs_grad)
    end
  end

  def kindergarten_variation(district)
    @state = @dr.districts.shift.last if @state.nil?
    d_kin = @dr.find_by_name(district).enrollment.enrollment_data[:kindergarten_participation]
    s_kin = @state.enrollment.enrollment_data[:kindergarten_participation]
    calculate_average(d_kin) / calculate_average(s_kin) unless d_kin.empty?
  end

  def subset_correlation_check(subset)
    qualifying_districts = 0
    subset[:across].each do |district|
      if single_district_correlation_check(district)
        qualifying_districts += 1
      end
    end
    subset_correlation_confirmation(qualifying_districts, subset)
  end

  def subset_correlation_confirmation(qualifying_districts, subset)
    if qualifying_districts > subset.count * 0.7
      true
    else
      false
    end
  end

  def statewide_correlation_check
    qualifying_districts = 0
    @state = @dr.districts.shift.last if @state.nil?
    @dr.districts.each do |name, information|
    if single_district_correlation_check(name)
      qualifying_districts += 1 
    end
    end
    statewide_correlation_confirmation(qualifying_districts)
  end

  def statewide_correlation_confirmation(qualifying_districts)
    if qualifying_districts > (180 * 0.7)
      true
    else
      false
    end
  end
    
  def find_poverty_and_hs_grad
    @rs = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last if @state.nil?
    @dr.districts.each do |name, district|
      bad_enrollment_data_swap(district.enrollment.enrollment_data)
      bad_econ_data_swap(district.economic_profile.economic_data)
      format_high_poverty_and_hs_graduation(district) if lunch?(district)
    end
  end

  def find_income_disparity
    @rs = ResultSet.new({:matching_districts => [], :statewide_average => nil})
    @state = @dr.districts.shift.last if @state.nil?
    @dr.districts.each do |name, district|
      bad_enrollment_data_swap(district.enrollment.enrollment_data)
      bad_econ_data_swap(district.economic_profile.economic_data)
      format_income_disparity(district) if median_income?(district)
    end
  end

  def bad_enrollment_data_swap(district_data)
    district_data.each do |category, stat|
      extract_bad_enrollment_data(category, stat) if stat.class == Hash
    end
  end

  def extract_bad_enrollment_data(category, stat)
    stat.delete_if do |year, percent|
      percent == 0.0
    end
  end

  def bad_econ_data_swap(district_data)
    district_data.each do |category, data|
    if data.class == Hash
      extract_bad_econ_data(category, data)
    elsif data.class == Fixnum || data.class == Float
      data.delete_if{|year, percent| percent == 0.0}
    end
    end
  end

  def extract_bad_econ_data(category, data)
    if data.all?{|key, value|value.class == Hash}
      data.each do |subject, scores_by_year|
      scores_by_year.delete_if{|yr,pct|pct==0.0}
      end
    else
      data.delete_if{|yr,score|score==0.0}
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
    unless pov_children.nil?
      calculate_average(pov_children)
    end
  end
  
  def calculate_average(district_data)
    unless district_data.values.empty?
      district_data.values.reduce(:+) / district_data.count
    end
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
    @state = @dr.districts.shift.last if @state.nil?
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
      result + lunch[:percentage].to_f
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
     @state = @dr.districts.shift.last if @state.nil?
     kindergarten_variation(district) / median_income_variation(district) unless kindergarten_variation(district).nil?
   end

   def median_income_variation(district)
     median_income(@dr.find_by_name(district)).to_f / state_median_income.to_f
   end


   def kindergarten_participation_correlates_with_household_income(district)
    if district.keys.include?(:across)
     kp_and_hh_income_correlation_across_districts(district[:across])
    elsif district[:for] == "STATEWIDE"
     statewide_income_correlation
    else
      kindergarten_vs_household_income_correlation(district[:for])
    end
   end

   def kindergarten_vs_household_income_correlation(district)
     if (0.6..1.5).cover?(kindergarten_participation_against_household_income(district))
       true
     end
   end

   def kp_and_hh_income_correlation_across_districts(districts)
     correlated_districts = districts.reduce([]) do |result, district|
       result << kindergarten_participation_correlates_with_household_income({:for => district})
     end
     correlation_confirmation(correlated_districts)
   end

   def correlation_confirmation(correlated_districts)
     if correlated_districts.compact.empty?
       false
     else
       find_correlation_districts(correlated_districts)
     end
   end

   def find_correlation_districts(correlated_districts)
     correlated_districts.all?{|val|val == true}
   end

   def statewide_income_correlation
     @state = @dr.districts.shift.last if @state.nil?
     correlated = 0
     @dr.districts.each do |name, district|
       if kindergarten_participation_correlates_with_household_income({:for => name})
         correlated += 1
       end
     end
     correlation_check?(correlated)
   end

   def correlation_check?(correlated)
     true if correlated > (@dr.districts.count * 0.7)
   end
end
