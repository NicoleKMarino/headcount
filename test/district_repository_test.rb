require 'minitest/autorun'
require 'minitest/pride'
require './lib/District/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new

    @dr.load_data({:enrollment => {:kindergarten => './test/test_kindergartners_in_full_day_program.csv'}})
  end

  def test_can_load_data
    assert @dr.districts.all?{|district|district.class == District}
  end

  def test_can_find_district_by_name
    binding.pry
    assert_instance_of District , @dr.find_by_name("Sheridan 2")
    assert_equal "SHERIDAN 2", @dr.find_by_name("Sheridan 2").name
  end
end