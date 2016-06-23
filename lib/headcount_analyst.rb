require_relative '../lib/result_set'
require_relative '../lib/result_entry'
require_relative "../lib/district_repository"
require_relative "../lib/enrollment_repository"
require_relative "../lib/economic_profile_repository"
require_relative '../lib/result_formatter'

class HeadcountAnalyst
  include ResultFormatter
  attr_reader :rs, :state
  def initialize(dr)
    @dr = dr
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

  def kindergarten_participation_rate_variation(district, competing_district)
    district_avg = kindergarten_variation(district)
    if competing_district[:against] == "COLORADO"
      competing_avg = kindergarten_variation("Colorado")
    else
      competing_avg = kindergarten_variation(competing_district[:against])
    end
    district_avg / competing_avg
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder = kindergarten_variation(district)
    grad = grad_avg(@dr.find_by_name(district)) / state_grad_avg
    kinder / grad 
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

  def kindergarten_variation(district)
    @state = @dr.districts.shift.last if @state.nil?
    d_kin = @dr.find_by_name(district).enrollment.enrollment_data[:kindergarten_participation]
    s_kin = @state.enrollment.enrollment_data[:kindergarten_participation]
    calculate_average(d_kin) / calculate_average(s_kin) unless d_kin.empty?
  end

end
