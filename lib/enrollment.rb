class Enrollment
  attr_reader :name
  def initialize(enrollment_data_by_district)
    @name = enrollment_data_by_district.dig(:name)
    @enrollment_data_by_district = enrollment_data_by_district
  end

  def kindergarten_participation_by_year
    @enrollment_data_by_district.dig(:kindergarten_participation).reduce({}) do |result,ptcptn_by_year|
      result.merge({ptcptn_by_year.first => ptcptn_by_year.last})
    end
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
    truncate_float(@enrollment_data_by_district.dig(:kindergarten_participation)[year])
  end

end
