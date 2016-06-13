<<<<<<< HEAD
require_relative "../lib/district"
require 'minitest/autorun'
require 'minitest/pride'

class DistrictTest < Minitest::Test
  def test_district_knows_name
    d = District.new({:name => "ACADEMY 20"})

    assert_equal "ACADEMY 20", d.name
  end
=======
require 'minitest/autorun'
require "./lib/district"


class DistrictTest < Minitest::Test


def test_has_name
  test=District.new(name:"ACADEMY 20")
  assert_equal test.name, "ACADEMY 20")
end

>>>>>>> 24c05a6cef476b03ae3afdbef205c8ff9dc02655
end
