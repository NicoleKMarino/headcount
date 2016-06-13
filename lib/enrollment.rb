class Enrollment
<<<<<<< HEAD
  attr_reader :name, :enrollment_data_by_district
=======
  attr_accessor :enrollment_data_by_district
  attr_reader :name
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
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
<<<<<<< HEAD
    (float * 1000).floor / 1000.to_f unless float == nil
=======
    unless float == nil
      (float * 1000).floor / 1000.to_f
    end
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
  end

  def kindergarten_participation_in_year(year)
    truncate_float(@enrollment_data_by_district.dig(:kindergarten_participation)[year])
  end

<<<<<<< HEAD
  def append_enrollment_data(conflicting_district)
    @enrollment_data_by_district.merge!(conflicting_district.enrollment_data_by_district)
  end

  def graduation_rate_by_year
    @enrollment_data_by_district.dig(:high_school_graduation).reduce({}) do |result, graduation_by_year|
=======
  def append_enrollment_data(conflicting_enrollment)
    @enrollment_data_by_district.merge!(conflicting_enrollment.enrollment_data_by_district)
  end

  def graduation_rate_by_year
      @enrollment_data_by_district.dig(:high_school_graduation).reduce({}) do |result, graduation_by_year|
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
      result.merge({graduation_by_year.first => truncate_float(graduation_by_year.last)})
    end
  end

  def graduation_rate_in_year(year)
    truncate_float(@enrollment_data_by_district.dig(:high_school_graduation)[year])
  end
end
