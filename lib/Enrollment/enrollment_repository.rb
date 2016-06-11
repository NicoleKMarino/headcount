require 'csv'
require 'pry'
require_relative 'enrollment'
require_relative '../../lib/parser'

class EnrollmentRepository
  include Parser
  attr_accessor :enrollments

  def initialize
    @parsed_data = Hash.new
    @enrollments = Hash.new
  end

  def load_data(kindergarten_enrollment_data)
    filename = kindergarten_enrollment_data.dig(:enrollment, :kindergarten)
    open_csv(filename)
  end

end
