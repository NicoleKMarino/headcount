require './lib/Enrollment/enrollment'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentTest < Minitest::Test
  def setup
  end

  def test_kindergarten_participation_by_year
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_instance_of Hash, enrollment.kindergarten_participation_by_year
    assert_equal 0.391, enrollment.kindergarten_participation_by_year[2010]
  end

  def test_kindergarten_participation_in_year
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.353, enrollment.kindergarten_participation_in_year(2011)
  end


end
