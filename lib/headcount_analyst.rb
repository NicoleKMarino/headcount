require "./lib/District/district_repository"
require "./lib/Enrollment/enrollment_repository"

class HeadcountAnalyst
  def initialize
    @dr= DistrictRepository.new
    @enrollment= @dr.load_data({:enrollment => {:kindergarten =>'./data/kindergartners_in_full_day_program.csv'}})
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
   
end

ha = HeadcountAnalyst.new
ha.kindergarten_participation_rate_variation("ACADEMy 20", "COLORADO")
