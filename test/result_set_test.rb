require 'pry'
require_relative '../lib/result_entry'
require_relative '../lib/result_set'
require 'minitest/autorun'
require 'minitest/pride'

class ResultSetTest < Minitest::Test
  def setup
    entry1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
                              children_in_poverty_rate: 0.25,
                              high_school_graduation_rate: 0.75})
    entry2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
                              children_in_poverty_rate: 0.2,
                              high_school_graduation_rate: 0.6})
    @set = ResultSet.new({matching_districts: [entry1], statewide_average: entry2})
  end

  def test_matching_districts
    assert_equal 0.5, @set.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.25, @set.matching_districts.first.children_in_poverty_rate
    assert_equal 0.75, @set.matching_districts.first.high_school_graduation_rate
  end

  def test_statewide_avg
    assert_equal 0.3, @set.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.2, @set.statewide_average.children_in_poverty_rate
    assert_equal 0.6, @set.statewide_average.high_school_graduation_rate
  end
end
