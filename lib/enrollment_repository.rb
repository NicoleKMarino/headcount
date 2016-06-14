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
    kindergarten_file = enrollment_data.dig(:enrollment, :kindergarten)
    hs_graduation_file = enrollment_data.dig(:enrollment, :high_school_graduation)
    sort_enrollment_request(kindergarten_file, hs_graduation_file)
  end

  def create_enrollment(district_name, enrollment_specs)
    new_enrollment = {district_name => Enrollment.new(enrollment_specs)}
    unless @enrollments[district_name] == nil
      @enrollments[district_name].append_enrollment_data(new_enrollment[district_name])
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
