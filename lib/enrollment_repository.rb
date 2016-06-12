require 'pry'
require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  include Parser
  attr_reader :enrollments

  def initialize
    @enrollments = Hash.new
    @filename
  end

  def load_data(enrollment_data)
    @parsed_data = Hash.new
    kindergarten_file = enrollment_data.dig(:enrollment, :kindergarten)
    hs_graduation_file = enrollment_data.dig(:enrollment, :high_school_graduation)
    sort_request(kindergarten_file, hs_graduation_file)
  end

  def sort_request(kindergarten_file, hs_graduation_file)
    open_csv(kindergarten_file) unless kindergarten_file == nil
    open_csv(hs_graduation_file) unless hs_graduation_file == nil
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
