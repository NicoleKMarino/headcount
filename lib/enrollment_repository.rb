require_relative 'enrollment'
require_relative 'parser'

class EnrollmentRepository
  include Parser
  attr_reader :enrollments

  def initialize
    @parsed_data = Hash.new
    @enrollments = Hash.new
  end

  def load_data(kindergarten_enrollment_data)
    filename = kindergarten_enrollment_data.dig(:enrollment, :kindergarten)
    open_csv(filename)
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
