require 'csv'
require 'pry'
require_relative 'enrollment'

class EnrollmentRepository

  def create_hash_from_data
    name = "Academy 20"
    kindergarten_participation = {:year => percent}
  end

  def load_data(weird_hash_thing)
    @data = CSV.open(filename, headers: true, header_converters: :symbol)
  end
end
