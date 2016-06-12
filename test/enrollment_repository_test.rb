require_relative '../lib/enrollment_repository'
require 'pry'
require_relative '../lib/parser'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentRepositoryTest < Minitest::Test
  def test_load_data
    skip
    enrollment_repo = EnrollmentRepository.new

    result = enrollment_repo.open_csv('./test/test_kindergartners_in_full_day_program.csv') 
    assert_instance_of Enrollment, result
  end

  def test_load_multiple_datas
    enrollment_repo = EnrollmentRepository.new

    enrollment_repo.load_data({:enrollment =>
                               {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                :high_school_graduation => "./data/High school graduation rates.csv"}})
  end
end

