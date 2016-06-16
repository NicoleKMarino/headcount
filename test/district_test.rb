require_relative "../lib/district_repository"
require_relative "../lib/district"
require 'minitest/autorun'
require 'minitest/pride'

class DistrictTest < Minitest::Test
  def test_district_knows_name
    d = District.new({:name => "ACADEMY 20"})

    assert_equal "ACADEMY 20", d.name
  end
end
