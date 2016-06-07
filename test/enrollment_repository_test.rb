require './lib/Enrollment/enrollment_repository'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentRepositoryTest < Minitest::Test
  def test_load_data
    enrollment_repo = EnrollmentRepository.new
    enrollment_repo.load_data({:enrollment => {:kindergarten => "./data/kindergartners_in_full_day_program.csv"}})

    assert_instance_of Enrollment, enrollment_repo.find_by_name("Academy 20")
    assert_instance_of Enrollment, enrollment_repo.find_by_name("AcADEMy 20")
  end

end

