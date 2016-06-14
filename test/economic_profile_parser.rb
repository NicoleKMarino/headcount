require_relative '../lib/economic_profile_repository'
require 'minitest/autorun'
require 'minitest/pride'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_can_do_shit
    epr = EconomicProfileRepository.new
    epr.load_data({:economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"
    }
    })
  end
end
