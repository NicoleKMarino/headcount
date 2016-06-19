class Enrollment
  attr_reader :name, :enrollment_data

  def initialize(enrollment_data_by_district)
    @enrollment_data = enrollment_data_by_district
    @name = @enrollment_data[:name]
  end

  def append_enrollment_data(conflicting_district)
    @enrollment_data.merge!(conflicting_district.enrollment_data)
  end

  def kindergarten_participation_by_year
    @enrollment_data[:kindergarten].reduce({}) do |result,ptcptn|
      result.merge({ptcptn.first => truncate_float(ptcptn.last)})
    end
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f unless float == nil
  end

  def kindergarten_participation_in_year(year)
    truncate_float(@enrollment_data.dig(:kindergarten)[year])
  end

  def graduation_rate_by_year
    @enrollment_data[:high_school_graduation].reduce({}) do |result, grdtn|
      result.merge({grdtn.first => truncate_float(grdtn.last)})
    end
  end

  def graduation_rate_in_year(year)
    truncate_float(@enrollment_data.dig(:high_school_graduation)[year])
  end
end
