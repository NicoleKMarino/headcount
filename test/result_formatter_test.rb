require_relative '../lib/result_formatter'
require 'minitest/autorun'
require 'minitest/pride'

class HeadcountAnalystTest < Minitest::Test
  def test_can_make_results
    ha = HeadcountAnalyst.new
  end
end
