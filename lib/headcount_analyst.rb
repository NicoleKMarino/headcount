require_relative 'result_entry'
require_relative 'result_set'
require_relative 'result_formatter'
require 'pry'
require_relative "district_repository"
require_relative "enrollment_repository"


class HeadcountAnalyst
  include ResultFormatter
  def initialize
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {:kindergarten =>'./data/Kindergartners in full-day program.csv',
                                  :high_school_graduation => './data/High school graduation rates.csv'}},
                                  {:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}},
    :economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"})
  end

  def district(name)
    find_district_average(@dr.find_by_name(name))
  end

  def find_district_average(district)
    average=district.enrollment.kindergarten_participation_by_year.values.reduce(:+) / district.enrollment.kindergarten_participation_by_year.length
  end

  def kindergarten_participation_rate_variation(district_name1, district_name2)
    district1 = district(district_name1)
    district2 = district(district_name2)
    result = district1 / district2
    display_result(result)
  end

  def display_result(result)
    if result < 1
      return "there was no significant change"
    else
      return "There was a significant change"
    end
  end


  def kindergarten_participation_rate_variation_trend(district_name1,district_name2)
    district1 =@dr.find_by_name(district_name1)
    district2 =@dr.find_by_name(district_name2)
    percents1 = district1.enrollment.enrollment_data_by_district[:kindergarten_participation]
    percents2= district2.enrollment.enrollment_data_by_district[:kindergarten_participation]
    result = percents1.merge(percents2){|k, a_value, b_value| a_value/b_value }
    answer= result.each do |k, v|
    result[k] = truncate_float(v)
    end
  end

  def truncate_float(float)
    unless float == nil
      (float * 1000).floor / 1000.to_f
    end
  end

  def graduation_rate_average(district_name)
    district=@dr.find_by_name(district_name)
    all_pp= district.enrollment.graduation_rate_by_year
    all_pp.values.reduce(:+) / all_pp.length
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    result = find_variations(district_name)
    if result.round == 1
      puts "There was a significant correlation"
      return result
    else
      puts "There wasn't a significant correlation"
      return result
    end
  end

  def find_statewide_correlation
    correlations=[]
    @dr.districts.each do |name,info|
      result = find_variations(name)
      if (0.6..1.5).cover?(result)
        correlations.push("true")
      else
        correlations.push("false")
      end
    end
    find_percentage(correlations)
  end


  def find_percentage(correlations)
    result = correlations.count("true")/correlations.length.to_f
    percent = result * 100
    if percent > 70
      return true
    else
      return false
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_name)
    if district_name.include? "STATEWIDE"
      find_statewide_correlation
    elsif district_name.class == Array
      find_variations_of_array(district_name)
    else
      result=find_variations(district_name)
      if (0.6..1.5).cover?(result)
        return true
      else
        return false
      end
    end
  end

  def find_variations_of_array(district_name)
    correlations=[]
    district_name.each do |district|
      result = kindergarten_participation_correlates_with_high_school_graduation(district)
      correlations.push(result)
    end
    find_percentage(correlations)
  end

  def find_variations(district_name)
    kindergarten_variation= district(district_name) / district("Colorado")
    hs_variation = graduation_rate_average(district_name) / graduation_rate_average("Colorado")
    result = kindergarten_variation/hs_variation
  end

   def find_statewide_correlation
     correlations = []
     @dr.districts.each do |name, info|
       kindergarten_variation = district(name) / district("Colorado")
       hs_variation = graduation_rate_average(name) / graduation_rate_average("Colorado")
       result = kindergarten_variation / hs_variation
       if (0.6..1.5).cover?(result)
         correlations.push(result)
       else
         "test"
       end
     end
   end
   def kindergarten_participation_correlates_with_high_school_graduation(district_name)
     kindergarten_variation= district(district_name) / district("Colorado")
     hs_variation=graduation_rate_average(district_name) / graduation_rate_average("Colorado")
     result= kindergarten_variation/hs_variation
     if (0.6..1.5).cover?(result)
       puts "There is a correlation"
     else
       puts "There wasnt a correlation"
     end
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
       dkin = @dr.find_by_name(district).enrollment.enrollment_data[:kindergarten_participation]
       skin = @state.enrollment.enrollment_data[:kindergarten_participation]
       calculate_average(dkin) / calculate_average(skin)
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
ha = HeadcountAnalyst.new
ha.kindergarten_participation_correlates_with_household_income(:across => ["ACADEMY 20", "YUMA SCHOOL DISTRICT 1"])
