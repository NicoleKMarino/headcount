require_relative '../lib/enrollment_repository'
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentRepositoryTest < Minitest::Test
  def test_load_data
    enrollment_repo = EnrollmentRepository.new

    result = enrollment_repo.open_csv('./data/Kindergartners in full-day program.csv') 

    assert_instance_of Enrollment, enrollment_repo.find_by_name("ACADEMY 20")

  end

  def test_load_multiple_datas
    skip
    enrollment_repo = EnrollmentRepository.new

    enrollment_repo.load_data({:enrollment =>
                               {:kindergarten => "./data/Kindergartners in full-day program.csv",
                                :high_school_graduation => "./data/High school graduation rates.csv"}})
  end
end

