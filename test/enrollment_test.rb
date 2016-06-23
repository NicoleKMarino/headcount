require_relative "../lib/enrollment"
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentTest < Minitest::Test
  def setup
    @enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2012 => 0.4596, 2013 => 0.526562, 2014 => 0.88245}})
  end

  def test_enrollment_knows_name
    assert_equal "ACADEMY 20", @enrollment.name
  end

  def test_kindergarten_participation_in_year
    assert_equal 0.882, @enrollment.kindergarten_participation_in_year(2014)
  end

  def test_kindergarten_participation_by_year
    expected_result = {2012 => 0.457, 2013 => 0.527, 2014 => 0.882}

    assert expected_result = @enrollment.kindergarten_participation_by_year
  end
end
