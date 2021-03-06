require_relative '../lib/errors'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'
require 'minitest/autorun'
require 'minitest/pride'

class StatewideTestTest < Minitest::Test
  def test_proficient_by_grade
    raw_data = {:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
                                             :reading => {2008 => 0.524, 2009 => 0.562, 2010 => 0.457, 2011 => 0.571},
                                             :writing => {2008 => 0.426, 2009 => 0.479, 2010 => 0.312, 2011 => 0.31}}}
    swt = StatewideTest.new(raw_data)
    predicted_result = {:math => 0.56, :reading => 0.524, :writing => 0.426}
    

    assert_equal [2008, 2009, 2010, 2011], swt.proficient_by_grade(3).keys
    assert_equal predicted_result, swt.proficient_by_grade(3)[2008]
  end

  def test_sw_test_holds_multiple_grades
    sw = StatewideTest.new({:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
                                             :reading => {2008 => 0.524, 2009 => 0.562, 2010 => 0.457, 2011 => 0.571},
                                             :writing => {2008 => 0.426, 2009 => 0.479, 2010 => 0.312, 2011 => 0.31}},
                            :eighth_grade => {:math => {2008 => 0.22, 2009 => 0.3, 2010 => 0.42, 2011 => 0.37702},
                                              :reading => {2008 => 0.426, 2009 => 0.398, 2010 => 0.514, 2011 => 0.4879},
                                              :writing => {2008 => 0.444, 2009 => 0.471, 2010 => 0.376, 2011 => 0.33065}},
                            :math => {:white => {2011 => 0.3814, 2012 => 0.3339, 2013 => 0.3551, 2014 => 0.4034},
                                      :black => {2011 => 0.1961, 2012 => 0.2252, 2013 => 0.2897, 2014 => 0.2}},
                            :reading => {:white => {2011 => 0.522, 2012 => 0.48524, 2013 => 0.53455, 2014 => 0.0053},
                                         :black => {2011 => 0.3333, 2012 => 0.32432, 2013 => 0.39091, 2014 => 0.30909}},
                            :writing => {:white => {2011 => 0.3462, 2012 => 0.2762, 2013 => 0.3388, 2014 => 0.3402},
                                         :black => {2011 => 0.2255, 2012 => 0.2162, 2013 => 0.2593, 2014 => 0.2182}}})

    assert_equal [2008, 2009, 2010, 2011], sw.proficient_by_grade(3).keys
  end

  def test_proficient_by_ethnicity 
    sw = StatewideTest.new({:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
                                             :reading => {2008 => 0.524, 2009 => 0.562, 2010 => 0.457, 2011 => 0.571},
                                             :writing => {2008 => 0.426, 2009 => 0.479, 2010 => 0.312, 2011 => 0.31}},
                            :eighth_grade => {:math => {2008 => 0.22, 2009 => 0.3, 2010 => 0.42, 2011 => 0.37702},
                                              :reading => {2008 => 0.426, 2009 => 0.398, 2010 => 0.514, 2011 => 0.4879},
                                              :writing => {2008 => 0.444, 2009 => 0.471, 2010 => 0.376, 2011 => 0.33065}},
                            :math => {:white => {2011 => 0.3814, 2012 => 0.3339, 2013 => 0.3551, 2014 => 0.4034},
                                      :black => {2011 => 0.1961, 2012 => 0.2252, 2013 => 0.2897, 2014 => 0.2}},
                            :reading => {:white => {2011 => 0.522, 2012 => 0.48524, 2013 => 0.53455, 2014 => 0.0053},
                                         :black => {2011 => 0.3333, 2012 => 0.32432, 2013 => 0.39091, 2014 => 0.30909}},
                            :writing => {:white => {2011 => 0.3462, 2012 => 0.2762, 2013 => 0.3388, 2014 => 0.3402},
                                         :black => {2011 => 0.2255, 2012 => 0.2162, 2013 => 0.2593, 2014 => 0.2182}}})

    assert_equal 0.381, sw.proficient_for_subject_by_race_in_year(:math, :white, 2011)
  end

  def test_unknown_data_errors
    str = StatewideTestRepository.new

    str.load_data({:statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
    })
    testing = str.find_by_name("AULT-HIGHLAND RE-9")

    assert_raises(UnknownDataError) do
      testing.proficient_by_grade(1)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end
assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:reading, :pizza, 2013)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:pizza, :white, 2013)
    end
  end
end
