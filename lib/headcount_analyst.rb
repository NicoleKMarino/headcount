require "/Users/Nicole/Documents/mod1/headcount/lib/District/district_repository.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/Enrollment/enrollment_repository.rb"

class HeadcountAnalyst
  def initialize
    @dr= DistrictRepository.new
    @enrollment_k= @dr.load_data({:enrollment => {:kindergarten =>'/Users/Nicole/Documents/mod1/headcount/data/kindergartners_in_full_day_program.csv'}})
    # @enrollment_hs = @dr.load_data({:enrollment => {:#high school" =>'/Users/Nicole/Documents/mod1/headcount/data/kindergartners_in_full_day_program.csv'}})
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
     binding.pry
     if result < 1
       puts "there was no significant change"
     else
       puts "There was a significant change"
     end
   end

   def find_average_by_year(district_name)
     percents = district_name.enrollment.kindergarten_participation_by_year
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


   #
  #  def kindergarten_participation_against_high_school_graduation(district_name)
   #
  #  end



 end

 ha = HeadcountAnalyst.new
 ha.kindergarten_participation_rate_variation_trend("ACADEMY 20", "COLORADO")
