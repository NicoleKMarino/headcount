require 'minitest/autorun'
require "./lib/district"


class DistrictTest < Minitest::Test


def test_has_name
  test=District.new(name:"ACADEMY 20")
  assert_equal test.name, "ACADEMY 20")
end

end
