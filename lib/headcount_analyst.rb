require_relative "district_repository"
require_relative "enrollment_repository"

class HeadcountAnalyst
  def initialize(dr=DistrictRepository.new)
    @dr = dr
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
end
