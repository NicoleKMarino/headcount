require_relative '../lib/result_entry'
require 'minitest/autorun'
require 'minitest/pride'

class ResultEntryTest < Minitest::Test
  def setup
    @entry = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
                             children_in_poverty: 0.25,
                             high_school_graduation_rate: 0.75,
                             median_household_income: 0.5})

  end

  def test_reduced_price_lunch
    assert_equal 0.5, @entry.free_and_reduced_price_lunch_rate
  end

  def test_children_in_poverty
    assert_equal 0.25, @entry.children_in_poverty_rate
  end

  def test_hs_graduation
    assert_equal 0.75, @entry.high_school_graduation_rate
  end

  def test_median_household_income
    assert_equal 0.5, @entry.median_household_income
  end
end
