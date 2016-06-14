require_relative 'statewide_test'
require_relative 'statewide_parser'
require 'pry'

class StatewideRepository
  include StatewideParser
  attr_reader :statewide_tests
  def initialize
    @statewide_tests = Hash.new
  end

  def load_data(statewide_hash)
    @parsed_data = Hash.new
    assert_files(statewide_hash)
  end

  def create_sw_test(district, scores_by_district)
    new_test = ({district => StatewideTest.new(scores_by_district)})
    unless @statewide_tests[district] == nil
      @statewide_tests[district].append_new_data(new_test[district])
    else
      add_statewide_test(new_test)
    end
  end

  def add_statewide_test(new_test)
    @statewide_tests.merge!(new_test)
  end
end
