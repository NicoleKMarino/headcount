require_relative '../lib/proficiency_parser'
require 'minitest/autorun'
require 'minitest/pride'

class ProficiencyParserTest < Minitest::Test
  def test_parser_can_sort_data
    parser = ProficiencyParser.new
    raw_data = {:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
                                             :reading => {2008 => 0.524, 2009 => 0.562, 2010 => 0.457, 2011 => 0.571},
                                             :writing => {2008 => 0.426, 2009 => 0.479, 2010 => 0.312, 2011 => 0.31}}}
    

    assert_equal [2008, 2009, 2010, 2011], parser.format_proficiency_by_year(raw_data[:third_grade]).keys
  end

  def test_sw_test_holds_multiple_grades
    parser = ProficiencyParser.new
    raw_data = {:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
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
                                         :black => {2011 => 0.2255, 2012 => 0.2162, 2013 => 0.2593, 2014 => 0.2182}}}

    assert_equal 0.469, parser.format_proficiency_by_year(raw_data[:third_grade])[2010][:math]
    assert parser.format_proficiency_by_year(raw_data[:eighth_grade]).all?{|key, value|value.include?(:math)}
    assert parser.format_proficiency_by_year(raw_data[:eighth_grade]).all?{|key, value|value.include?(:reading)}
    assert parser.format_proficiency_by_year(raw_data[:eighth_grade]).all?{|key, value|value.include?(:writing)}
  end

  def test_parser_can_parse_ethnicity
    raw_data = {:third_grade => {:math => {2008 =>0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476},
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
                                         :black => {2011 => 0.2255, 2012 => 0.2162, 2013 => 0.2593, 2014 => 0.2182}}}
    parser = ProficiencyParser.new

    assert_equal 0.522, parser.format_proficiency_by_ethnicity(raw_data, :white)[2011][:reading]
    assert parser.format_proficiency_by_ethnicity(raw_data, :white).all?{|key, value|value.include?(:math)}
    assert parser.format_proficiency_by_ethnicity(raw_data, :white).all?{|key, value|value.include?(:reading)}
    assert parser.format_proficiency_by_ethnicity(raw_data, :white).all?{|key, value|value.include?(:writing)}
  end
end
