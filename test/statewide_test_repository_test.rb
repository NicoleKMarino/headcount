require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'
require 'minitest/autorun'
require 'minitest/pride'

class StatewideTestRepositoryTest < Minitest::Test
  def setup
    @sr = StatewideTestRepository.new
    @sr.load_data({:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
    })
  end

  def test_can_find_by_name
    assert_instance_of StatewideTest, @sr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", @sr.find_by_name("ACADEMY 20").name
  end


end
