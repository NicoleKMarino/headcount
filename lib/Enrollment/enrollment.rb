require 'pry'

class Enrollment
  attr_reader :name
  def initialize(enrollment_data_by_district)
    @enrollment_data_by_district = enrollment_data_by_district
    @sorted_enrollments = Hash.new
    @name = enrollment_data_by_district[:name]
    format_args
  end

  def format_args
    @enrollment_data_by_district[:kindergarten_participation].each do |key,value|
      @sorted_enrollments[key] = truncate_float(value)
    end
  end

  def kindergarten_participation_by_year
    @sorted_enrollments
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end

  def kindergarten_participation_in_year(year)
    @sorted_enrollments[year]
  end

end
