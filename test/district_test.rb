
require_relative "../lib/district"
require 'minitest/autorun'
require 'minitest/pride'


class DistrictTest < Minitest::Test


def test_has_name
  test=District.new(name:"ACADEMY 20")
  assert_equal test.name, "ACADEMY 20")
end


end
