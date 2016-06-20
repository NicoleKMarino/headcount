require_relative 'result_entry'
require_relative 'economic_profile_repository'
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
    @epr = EconomicProfileRepository.new
    @districts = Hash.new
  end

  def load_data(repo_files)
    @er.load_data(repo_files)
    create_districts(@er.enrollments)
    statewide_tests(repo_files) unless repo_files[:statewide_testing] == nil
    economic_profiles(repo_files) unless repo_files[:economic_profile] == nil
  end

  def statewide_tests(statewide_hash)
    @sr.load_data(statewide_hash)
    create_statewide_tests(@sr.statewide_tests)
  end

  def economic_profiles(economic_profile_files)
    @epr.load_data(economic_profile_files)
    create_economic_profiles(@epr.economic_profiles)
  end

  def create_districts(enrollments)
    enrollments.each do |district, enrollment_data|
      district = District.new({:name => enrollment_data.name})
      district.enrollment = enrollment_data
      districts[enrollment_data.name] = district
      @districts[enrollment_data.name] = district
    end
  end


  def create_statewide_tests(statewide_tests)
    statewide_tests.each do |district, statewide_proficiency|
      find_by_name(district).statewide_test = statewide_proficiency
      find_by_name(district).statewide_test.name = district
    end
  end

  def create_economic_profiles(economic_profiles)
    economic_profiles.each do |district, economic_profile|
      find_by_name(district).economic_profile = economic_profile
    end
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
