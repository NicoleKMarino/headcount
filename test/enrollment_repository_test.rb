require './lib/Enrollment/enrollment_repository'
require 'pry'
require './lib/parser'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentRepositoryTest < Minitest::Test
  def test_load_data
    enrollment_repo = EnrollmentRepository.new

    result = enrollment_repo.open_csv('./test/test_kindergartners_in_full_day_program.csv') 
    assert_instance_of Enrollment, result
  end
end

