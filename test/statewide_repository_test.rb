require_relative '../lib/statewide_repository'
require 'minitest/autorun'
require 'minitest/pride'

class StatewideRepositoryTest < Minitest::Test
  def test_can_identify_different_files
    sr = StatewideRepository.new
    sr.load_data({:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
    })
  end
end
