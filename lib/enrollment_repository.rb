<<<<<<< HEAD
require 'pry'
require_relative 'enrollment'
require_relative 'enrollment_parser'
class EnrollmentRepository
  include EnrollmentParser
=======
require 'csv'
require 'pry'
require_relative 'enrollment'
require "/Users/Nicole/Documents/mod1/headcount/lib/parser.rb"

class EnrollmentRepository
  include Parser
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
  attr_reader :enrollments

  def initialize
    @enrollments = Hash.new
<<<<<<< HEAD
=======
    @parsed_data = Hash.new
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
  end

  def load_data(enrollment_data)
    kindergarten_file = enrollment_data.dig(:enrollment, :kindergarten)
    hs_graduation_file = enrollment_data.dig(:enrollment, :high_school_graduation)
<<<<<<< HEAD
    sort_enrollment_request(kindergarten_file, hs_graduation_file)
  end

  def sort_enrollment_request(kindergarten_file, hs_graduation_file)
    open_csv(kindergarten_file) unless kindergarten_file == nil
    open_csv(hs_graduation_file) unless hs_graduation_file == nil
  end

  def create_enrollment(district_name, enrollment_specs)
    new_enrollment = {district_name => Enrollment.new(enrollment_specs)}
=======
    sort_request(kindergarten_file, hs_graduation_file)
  end

  def create_kindergarten_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :kindergarten_participation => @parsed_data[district_name].sort.to_h})}
    add_enrollment(new_enrollment)
  end

  def create_graduation_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :high_school_graduation => @parsed_data[district_name].sort.to_h})}
>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
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
