require 'pry'
require_relative "district_repository"
require_relative "enrollment_repository"


class HeadcountAnalyst
  def initialize
    @dr = DistrictRepository.new
    @enrollment= @dr.load_data({:enrollment => {:kindergarten => './data/Kindergartners in full-day program.csv', :high_school_graduation => './data/High school graduation rates.csv'}})
  end

  def district(name)
    find_district_average(@dr.find_by_name(name))
  end

  def find_district_average(district)
    district.enrollment.kindergarten_participation_by_year.values.reduce(:+) / district.enrollment.kindergarten_participation_by_year.length
  end

  def kindergarten_participation_rate_variation(district_name1, district_name2)
    district1 = district(district_name1)
    district2 = district(district_name2)
    result = district1 / district2
  end

  def display_result(result)
    if result < 1
      "there was no significant change"
    else
      "There was a significant change"
    end
  end

   def kindergarten_participation_rate_variation_trend(district_name1,district_name2)
     district1 = @dr.find_by_name(district_name1)
     district2 = @dr.find_by_name(district_name2)
     percents1 = find_average_by_year(district1)
     percents2 = find_average_by_year(district2)
     yearly_difference = percents1.map do |key,value|
       percents2value = percents2[key]
       value/percents2value
    end
    puts yearly_difference
   end

   def graduation_rate_by_year(district_name)
     district = @dr.find_by_name(district_name)
     @dr = district
     district.enrollment.graduation_rate_by_year
   end

   def graduation_rate_in_year(year)
     rates = @dr.enrollment.graduation_rate_by_year
     rates.each do |key,value|
       if key.to_i == year
        return value
       else
         nil
       end
     end
   end

   def graduation_rate_average(district_name)
     district=@dr.find_by_name(district_name)
     all_pp= district.enrollment.graduation_rate_by_year
     all_pp.values.reduce(:+) / all_pp.length
   end

   def kindergarten_participation_against_high_school_graduation(district_name)
     kindergarten_variation= district(district_name) / district("Colorado")
     hs_variation=graduation_rate_average(district_name) / graduation_rate_average("Colorado")
     result= kindergarten_variation/hs_variation
     if result.round == 1
       puts "There was a significant correlation"
     else
       puts "There wasn't a significant correlation"
    end
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

  def find_matching_districts
    @dr.districts.each do |name, district|
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
end
