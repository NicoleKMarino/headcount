require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_can_load_data
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {:kindergarten_participation => './data/Kindergartners in full-day program.csv'}})
    
    assert dr.districts.all?{|name, district|district.class == District}
  end

  def test_can_find_district_by_name
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {:kindergarten_participation => './data/Kindergartners in full-day program.csv'}})

    assert_instance_of District , dr.find_by_name("Sheridan 2")
    assert_equal "SHERIDAN 2", dr.find_by_name("Sheridan 2").name
  end

  def test_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten_participation => './data/Kindergartners in full-day program.csv'}})
    matching_districts = dr.find_all_matching("st")

    assert_instance_of Array, matching_districts
  end

  def test_can_load_multiple_files
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten_participation =>'./data/Kindergartners in full-day program.csv',
                                  :high_school_graduation => './data/High school graduation rates.csv'},
                                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                  }})

    matching_districts = dr.find_all_matching("st")

    assert_instance_of District , dr.find_by_name("Sheridan 2")
    assert_instance_of Array, matching_districts
    assert_equal "SHERIDAN 2", dr.find_by_name("Sheridan 2").name
  end

  def test_can_load_economic_profiles
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten_participation =>'./data/Kindergartners in full-day program.csv',
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

    matching_districts = dr.find_all_matching("st")

    assert_instance_of District , dr.find_by_name("Sheridan 2")
    assert_instance_of Array, matching_districts
    assert_equal "SHERIDAN 2", dr.find_by_name("Sheridan 2").name
  end
end
