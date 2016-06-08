require 'csv'
require 'pry'
require_relative 'enrollment'
require './lib/parser'

class EnrollmentRepository
  include Parser
  attr_accessor :parsed_data

  def initialize
    @parsed_data = Array.new
  end

  def create_hash_from_data
    name = "Academy 20"
    kindergarten_participation = {:year => percent}
  end

  def load_data(weird_hash_thing)
    @data = CSV.open(filename, headers: true, header_converters: :symbol)
  end
end
e = EnrollmentRepository.new
e.open_csv("./data/kindergartners_in_full_day_program.csv")
