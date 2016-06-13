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

  def assert_files(statewide_hash)
    statewide_testing = statewide_hash.dig(:statewide_testing)
    valid_tests = Array.new
    valid_tests << statewide_testing.dig(:third_grade)
    valid_tests << statewide_testing.dig(:eighth_grade)
    valid_tests << statewide_testing.dig(:math)
    valid_tests << statewide_testing.dig(:reading)
    valid_tests << statewide_testing.dig(:writing)
    load_requests(valid_tests)
  end

  def load_requests(tests)
    tests.each do |test|
      open_csv(test) unless test == nil
    end
  end

  def create_third_grade_sw_test(district, scores_by_district)
    new_test = ({district => StatewideTest.new(scores_by_district)})
    add_statewide_test(new_test)
  end

  def create_eighth_grade_sw_test(district, scores_by_district)
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
