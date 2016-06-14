require_relative 'statewide_test_repository'
require_relative 'enrollment_repository'
require_relative 'district'
require_relative 'statewide_test'
require 'pry'

class DistrictRepository
  attr_reader :districts, :statewide_tests
  def initialize
    @er = EnrollmentRepository.new
    @sr = StatewideTestRepository.new
  end

  def load_data(enrollment_hash, statewide_hash=nil)
    @er.load_data(enrollment_hash)
    create_districts(@er.enrollments)
    unless statewide_hash == nil
      @sr.load_data(statewide_hash)
      create_statewide_tests(@sr.statewide_tests)
    end
  end

  def create_districts(enrollments)
    @districts = Hash.new
    enrollments.each do |district, enrollment_data|
      district = District.new({:name => enrollment_data.name})
      district.enrollment = enrollment_data
      districts[enrollment_data.name] = district
    end
  end

  def create_statewide_tests(statewide_tests)
    statewide_tests.each do |district, statewide_proficiency|
      find_by_name(district).statewide_test = statewide_proficiency
    end
    binding.pry
  end

  def find_by_name(district_name)
    if district_name.class == Hash
      sort_request(district_name)
    elsif district_name == "Colorado"
      @districts[district_name]
    else
      @districts[district_name.upcase]
    end
  end

  def sort_request(district_name)
    if district_name.keys.first == :against
      find_by_name(district_name.dig(:against).upcase)
    end 
  end

  def find_all_matching(district_fragment)
    @districts.values.find_all do |dstrct|
      dstrct if dstrct.name.include?(district_fragment.upcase)
    end
  end
end
