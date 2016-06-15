require 'pry'
require_relative 'enrollment'
require_relative 'enrollment_parser'

class EnrollmentRepository
  include EnrollmentParser
  attr_reader :enrollments

  def initialize
    @enrollments = Hash.new
    @parsed_data = Hash.new
  end

  def load_data(enrollment_data)
    kindergarten_file = enrollment_data[:enrollment][:kindergarten]
    hs_graduation_file = enrollment_data[:enrollment][:high_school_graduation]
    sort_enrollment_request(kindergarten_file, hs_graduation_file)
  end

  def create_enrollment(district, enrollment_specs)
    new_enrollment = {district => Enrollment.new(enrollment_specs)}
    unless @enrollments[district] == nil
      @enrollments[district].append_enrollment_data(new_enrollment[district])
    else
      add_enrollment(new_enrollment)
    end
  end

  def add_enrollment(new_enrollment)
    @enrollments.merge!(new_enrollment)
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
