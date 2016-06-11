require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new

    @dr.load_data({:enrollment => {:kindergarten => './data/kindergartners_in_full_day_program.csv'}})
  end

  def test_can_load_data
    binding.pry
    assert @dr.districts.all?{|district|district.class == District}
  end

  def test_can_find_district_by_name
    assert_instance_of District , @dr.find_by_name("Sheridan 2")
    assert_equal "SHERIDAN 2", @dr.find_by_name("Sheridan 2")
  end

  def test_can_find_all_matching
    matching_districts = @dr.find_all_matching("st")

    assert_instance_of Array, matching_districts
  end
end
