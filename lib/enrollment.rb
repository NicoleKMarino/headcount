class Enrollment
  attr_reader :name, :enrollment_data_by_district

  def initialize(enrollment_data_by_district)
    @name = enrollment_data_by_district.dig(:name)
    @enrollment_data_by_district = enrollment_data_by_district
  end

  def kindergarten_participation_by_year
    @enrollment_data_by_district.dig(:kindergarten_participation).reduce({}) do |result,ptcptn_by_year|
      result.merge({ptcptn_by_year.first => truncate_float(ptcptn_by_year.last)})
    end
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f unless float == nil
  end

  def kindergarten_participation_in_year(year)
    truncate_float(@enrollment_data_by_district.dig(:kindergarten_participation)[year])
  end

  def append_enrollment_data(conflicting_district)
    @enrollment_data_by_district.merge!(conflicting_district.enrollment_data_by_district)
  end

  def graduation_rate_by_year
    @enrollment_data_by_district.dig(:high_school_graduation).reduce({}) do |result, graduation_by_year|
      result.merge({graduation_by_year.first => truncate_float(graduation_by_year.last)})
    end
  end

  def graduation_rate_in_year(year)
    truncate_float(@enrollment_data_by_district.dig(:high_school_graduation)[year])
  end
end
