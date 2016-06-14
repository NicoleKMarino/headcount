require 'csv'
require 'pry'
require "/Users/Nicole/Documents/mod1/headcount/lib/enrollment.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/parser.rb"

class EnrollmentRepository
  include Parser
  attr_reader :enrollments

  def initialize
    @enrollments = Hash.new
    @parsed_data = Hash.new
  end

  def load_data(enrollment_data)
    kindergarten_file = enrollment_data.dig(:enrollment, :kindergarten)
    hs_graduation_file = enrollment_data.dig(:enrollment, :high_school_graduation)
    sort_request(kindergarten_file, hs_graduation_file)
  end

  def create_kindergarten_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :kindergarten_participation => @parsed_data[district_name].sort.to_h})}
    add_enrollment(new_enrollment)
  end

  def create_graduation_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :high_school_graduation => @parsed_data[district_name].sort.to_h})}
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
