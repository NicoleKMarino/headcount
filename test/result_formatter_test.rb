require 'pry'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'
require 'minitest/autorun'
require 'minitest/pride'

class ResultFormatterTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {
                                  :high_school_graduation => './test/test_High school graduation rates.csv',
                                  :kindergarten => './test/test Kindergartners in full-day program.csv'},
    :economic_profile => {
                    :median_household_income => "./test/test_Median_household_income.csv",
                    :children_in_poverty => "./test/test_school_age_children_in_poverty.csv",
                    :free_or_reduced_price_lunch => "./test/test_Students_qualifying_for_free_or_reduced_lunch.csv",
                    :title_i => "./test/test_Title_I_students.csv"}})
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_find_pov_and_hs_grad_hs_grad
    @ha.high_poverty_and_high_school_graduation

    dummy_graduation = ((0.9 * 3) + (0.8 * 2)) / (3 + 2)
    matching_district = @ha.rs.matching_districts.first.high_school_graduation_rate
    state = @ha.rs.statewide_average.high_school_graduation_rate

    assert_equal dummy_graduation.round(3), matching_district
    assert matching_district > state
  end

  def test_find_pov_hs_grad_lunch
    @ha.high_poverty_and_high_school_graduation

    dummy_lunch_rate = 0.9
    matching_district = @ha.rs.matching_districts.first.free_and_reduced_price_lunch_rate
    state = @ha.rs.statewide_average.free_and_reduced_price_lunch_rate

    assert_equal dummy_lunch_rate, matching_district
    assert matching_district > state
  end

  def test_find_pov_hs_grad_children_in_poverty
    @ha.high_poverty_and_high_school_graduation

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

  def test_kindergarten_participation_against_household_income
    @ha.high_poverty_and_high_school_graduation
    academy = "Academy 20"

    dummy_participation = ((0.7 * 6) + (0.8 * 5)) / (5 + 6)
    state_participation = @ha.calculate_average(@ha.state.enrollment.enrollment_data[:kindergarten_participation])
    kindergarten_var = dummy_participation / state_participation

    dummy_income = ((60000 * 3) + (70000 * 2)) / (3 + 2)
    income_var = dummy_income / @ha.state_median_income.to_f
    expected_result = kindergarten_var / income_var

    assert_equal expected_result, @ha.kindergarten_participation_against_household_income(academy)
  end

  def test_kindergarten_participation_correlates_with_household_income
    @ha.high_poverty_and_high_school_graduation
    academy = "Academy 20"

    dummy_participation = ((0.7 * 6) + (0.8 * 5)) / (5 + 6)
    state_participation = @ha.calculate_average(@ha.state.enrollment.enrollment_data[:kindergarten_participation])
    kindergarten_var = dummy_participation / state_participation

    dummy_income = ((60000 * 3) + (70000 * 2)) / (3 + 2)
    income_var = dummy_income / @ha.state_median_income.to_f
    correlation = @ha.kindergarten_participation_against_household_income(academy)

    assert correlation > 1
    assert @ha.kindergarten_participation_correlates_with_household_income(for: academy)
  end

  def test_participation_correlates_with_income_statewide
    @ha.high_poverty_and_high_school_graduation
    academy = "Academy 20"
    adams = "Adams county 14"

    academy_participation = ((0.7 * 6) + (0.8 * 5)) / (5 + 6)
    adams_participation = ((0.3 * 6) + (0.2 * 5)) / (5 + 6)
    state_participation = @ha.calculate_average(@ha.state.enrollment.enrollment_data[:kindergarten_participation])
    academy_kindergarten_var = academy_participation / state_participation
    adams_kindergarten_var = adams_participation / state_participation

    academy_income = ((60000 * 3) + (70000 * 2)) / (3 + 2)
    adams_income = ((20000 * 3) + (30000 * 2)) / (3 + 2)
    academy_income_var = academy_income / @ha.state_median_income.to_f
    adams_income_var = adams_income / @ha.state_median_income.to_f

    academy_correlation = @ha.kindergarten_participation_correlates_with_household_income(for: academy)
    adams_correlation = @ha.kindergarten_participation_correlates_with_household_income(for: adams)

    assert academy_correlation
    assert adams_correlation
    assert @ha.kindergarten_participation_correlates_with_household_income(for: 'STATEWIDE')
    assert @ha.kindergarten_participation_correlates_with_household_income(:across => [academy, adams])
  end
end
