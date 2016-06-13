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
     district1 =@dr.find_by_name(district_name1)
     district2 =@dr.find_by_name(district_name2)
     percents1= find_average_by_year(district1)
     percents2= find_average_by_year(district2)
     yearly_difference = percents1.map do |key,value|
       percents2value=percents2[key]
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


   def kindergarten_participation_correlates_with_high_school_graduation(district_name)
     kindergarten_variation= district(district_name) / district("Colorado")
     hs_variation=graduation_rate_average(district_name) / graduation_rate_average("Colorado")
     result= kindergarten_variation/hs_variation
     if result.between?(0.6, 1.5)
       puts "There is a correlation"
     else
       puts "There wasnt a correlation"
   end
 end
end
