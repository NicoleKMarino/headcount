require "/Users/Nicole/Documents/mod1/headcount/lib/District/district_repository.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/Enrollment/enrollment_repository.rb"

class HeadcountAnalyst
  def initialize
    @dr= DistrictRepository.new
    @enrollment= @dr.load_data({:enrollment => {:kindergarten =>'/Users/Nicole/Documents/mod1/headcount/data/kindergartners_in_full_day_program.csv'}})
  end

def district(name)
  @district=@dr.find_by_name(name)
  find_district_average
end

  def find_district_average
    percents = @district.enrollment.kindergarten_participation_by_year.values
    result= percents.reduce(:+) / percents.length
  end

end

  def kindergarten_participation_rate_variation(district1,district2)
    district1 = find_district_average(district1)
    district2 = find_district_average(district2)
    result = district1 / district2
    if result > 1
      puts "there was no significant change"
    else
      puts "There was a significant change"
  end
end

  # def kindergarten_participation_rate_variation_trend
  # end
end
