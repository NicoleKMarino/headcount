require "/Users/Nicole/Documents/mod1/headcount/lib/headcount_analyst.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/enrollment_repository.rb"
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'


class HeadcountAnalysisTest < Minitest::Test


  def test_find_district_average
    ha = HeadcountAnalyst.new
    result = ha.district("ACADEMY 20")
    assert_equal result, 0.4060909090909091
  end


  def test_kindergarten_participation_rate_variation
    ha = HeadcountAnalyst.new
    result = ha.kindergarten_participation_rate_variation("ACADEMY 20", "ADAMS COUNTY 14")
    assert_equal result, "there was no significant change"
  end


  def test_kindergarten_participation_rate_variation_trend
    ha= HeadcountAnalyst.new
    result = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20','Colorado')
    answer = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661}
    assert_equal result, answer
  end

 def test_graduation_rate_by_year
   ha= HeadcountAnalyst.new
   result= ha.graduation_rate_by_year("ACADEMY 20")
  assert_equal result, { 2010 => 0.895,
     2011 => 0.895,
     2012 => 0.889,
     2013 => 0.913,
     2014 => 0.898,
     }
 end

 def test_graduation_rate_in_year
   ha= HeadcountAnalyst.new
   result= ha.graduation_rate_in_year("2010")
   edge_case=ha.graduation_rate_in_year("4009")
   assert_equal result, 0.895
   assert_equal edge_case, nil
 end


end
