require 'csv'
require 'pry'
require_relative 'enrollment'
require './lib/parser'

class EnrollmentRepository
  include Parser
  attr_accessor :parsed_data, :enrollments

  def initialize
    @parsed_data = Array.new
    @enrollments = Array.new
  end

  def load_data(kindergarten_enrollment_data)
    filename = kindergarten_enrollment_data.dig[:enrollment, :kindergarten]
    open_csv(filename)
  end
end
