require "../headcount/lib/headcount_analyst.rb"
require "../headcount/lib/enrollment_repository.rb"
require_relative "../lib/district_repository"
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'


class HeadcountAnalysisTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({:enrollment => {:kindergarten =>'./data/Kindergartners in full-day program.csv',
                                  :high_school_graduation => './data/High school graduation rates.csv'},
                                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"},
    :economic_profile => {
                    :median_household_income => "./test/test_Median_household_income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"}})
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_find_district_average
    result = ha.district("ACADEMY 20")
    assert_equal 0.4060909090909091, result
  end

  def test_kindergarten_participation_rate_variation
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_rate_variation("ACADEMY 20", "ADAMS COUNTY 14")
    assert_equal result, "there was no significant change"
  end

  def test_kindergarten_participation_rate_variation_trend
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20','Colorado')
    answer = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661}
    assert_equal result, answer
  end

  def test_graduation_rate_average
    ha = HeadcountAnalyst.new
    result = ha.graduation_rate_average("Academy 20")
    assert_equal 0.898, result
  end

  def test_kindergarten_participation_against_high_school_graduation
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_against_high_school_graduation("Academy 20")
    assert_equal 0.6411849881537087, result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_correlates_with_high_school_graduation('ACADEMY 20')
    assert_equal true, result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_statewide
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_correlates_with_high_school_graduation('STATEWIDE')
    assert_equal false, result
  end

end
