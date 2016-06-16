require 'pry'
require_relative '../lib/economic_profile'
require 'minitest/autorun'
require 'minitest/pride'

class EconomicProfileTest < Minitest::Test
  def setup
    economic_data = {:median_household_income => {[2005, 2009] => 85060, [2006, 2010] => 85450, [2008, 2012] => 89615, [2007, 2011] => 88099, [2009, 2013] => 89953},
                     :name => "ACADEMY 20",
                     :children_in_poverty => {1995 => 0.032, 1997 => 0.035, 1999 => 0.032, 2000 => 0.031},
                     :free_lunch => {2000 => {:total => 369, :percentage => 0.02},
                                                  2001 => {:percentage => 0.0247, :total => 448},
                                                  2002 => {:total => 509, :percentage => 0.02722}},
                     :free_or_reduced_price_lunch => {2000 => {:total => 701, :percentage => 0.04},
                                                             2001 => {:percentage => 0.04714, :total => 805},
                                                             2002 => {:total => 905, :percentage => 0.0484}},
                     :reduced_price_lunch => {2000 => {:total => 332, :percentage => 0.02},
                                                           2001 => {:percentage => 0.02244, :total => 407},
                                                           2002 => {:total => 396, :percentage => 0.02118}},
                     :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    @ep = EconomicProfile.new(economic_data)
  end

  def test_profile_knows_district_name
    assert_equal "ACADEMY 20", @ep.name
  end

  def test_median_household_income
    year = 2012
    expected_result = (89615 + 89953/ 2)
    assert expected_result, @ep.median_household_income_in_year(year)
  end
  
  def test_median_household_income_avg
    expected_result = ((85060 + 85450 + 89615 + 88099 + 89953) / 5)

    assert expected_result, @ep.median_household_income_average
  end

  def test_children_in_poverty
    year = 1997
    expected_result = 0.035

    assert expected_result, @ep.children_in_poverty_in_year(year)
  end

  def test_free_or_reduced_lunch_percentage_in_year
    year = 2001
    expected_result = 0.047

    assert expected_result, @ep.free_or_reduced_price_lunch_percentage_in_year(year)
  end

  def test_free_or_reduced_lunch_number_in_year
    year = 2001
    expected_result = 805

    assert expected_result, @ep.free_or_reduced_price_lunch_number_in_year(year)
  end

  def test_title_i_in_year
    year = 2012
    expected_result = 0.01

    assert expected_result, @ep.title_i_in_year(year)
  end
end
