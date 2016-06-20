require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/district"
require_relative "../lib/district_repository"
require_relative "../lib/enrollment"
require_relative "../lib/statewide_test"
require_relative "../lib/economic_profile"

class DistrictTest < Minitest::Test

  def test_has_name
    test = District.new(name:"ACADEMY 20")
    assert_equal test.name, "ACADEMY 20"
  end

  def test_district_has_enrollments
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => './data/Kindergartners in full-day program.csv'}})

    district = dr.find_by_name("Academy 20")

    assert_instance_of Enrollment, district.enrollment
    assert_equal district.name, district.enrollment.name
  end

  def test_district_has_statewide_tests
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten =>'./data/Kindergartners in full-day program.csv',
                                  :high_school_graduation => './data/High school graduation rates.csv'},
                                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                  }})

    district = dr.find_by_name("Academy 20")

    assert_instance_of StatewideTest, district.statewide_test
    assert_equal district.name, district.statewide_test.name
  end

  def test_district_has_economic_profile
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten =>'./data/Kindergartners in full-day program.csv',
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
                    :title_i => "./data/Title I students.csv"
                      }})
    district = dr.find_by_name("Academy 20")

    assert_instance_of EconomicProfile, district.economic_profile
    assert_equal district.name, district.economic_profile.name
  end

end
