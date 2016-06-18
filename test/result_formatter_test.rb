require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require 'minitest/autorun'
require 'minitest/pride'

class ResultFormatterTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {
                                  :high_school_graduation => './test/test_High school graduation rates.csv'},
    :economic_profile => {
                    :median_household_income => "./test/test_Median_household_income.csv",
                    :children_in_poverty => "./test/test_school_age_children_in_poverty.csv",
                    :free_or_reduced_price_lunch => "./test/test_Students_qualifying_for_free_or_reduced_lunch.csv",
                    :title_i => "./test/test_Title_I_students.csv"}})
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_find_pov_and_hs_grad_hs_grad
    @ha.find_poverty_and_hs_grad

    dummy_graduation = ((0.9 * 3) + (0.8 * 2)) / (3 + 2)
    matching_district = @ha.rs.matching_districts.first.high_school_graduation_rate
    state = @ha.rs.statewide_average.high_school_graduation_rate

    assert_equal dummy_graduation.round(3), matching_district
    assert matching_district > state
  end

  def test_find_pov_hs_grad_lunch
    @ha.find_poverty_and_hs_grad

    dummy_lunch_rate = 0.9
    matching_district = @ha.rs.matching_districts.first.free_and_reduced_price_lunch_rate
    state = @ha.rs.statewide_average.free_and_reduced_price_lunch_rate

    assert_equal dummy_lunch_rate, matching_district
    assert matching_district > state
  end

  def test_find_pov_hs_grad_children_in_poverty
    @ha.find_poverty_and_hs_grad

    dummy_poverty_rate = ((0.7 * 9) + (0.9 * 8)) / (8 + 9)
    matching_district = @ha.rs.matching_districts.first.children_in_poverty_rate
    state = @ha.rs.statewide_average.children_in_poverty_rate

    assert_equal dummy_poverty_rate.round(3), matching_district
    assert matching_district > state
  end

  def test_income_disparity_household_income
    @ha.high_income_disparity

    dummy_income = ((60000 * 3) + (70000 * 2)) / (3 + 2)
    matching_district = @ha.rs.matching_districts.first.median_household_income
    state = @ha.rs.statewide_average.median_household_income

    assert_equal dummy_income, matching_district
    assert dummy_income > state
  end

  def test_income_disparity_children_in_poverty_rate
    @ha.high_income_disparity

    dummy_poverty_rate = ((0.7 * 9) + (0.9 * 8)) / (8 + 9)
    matching_district = @ha.rs.matching_districts.first.children_in_poverty_rate
    state = @ha.rs.statewide_average.children_in_poverty_rate

    assert_equal dummy_poverty_rate.round(3), matching_district
    assert matching_district > state
  end
end
