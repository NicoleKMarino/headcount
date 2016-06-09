require 'pry'
require_relative '../Enrollment/enrollment_repository'
require_relative 'district'
class DistrictRepository
  attr_reader :districts
  def initialize
    @er = EnrollmentRepository.new
  end

  def load_data(enrollment_hash)
    @er.load_data(enrollment_hash)
    create_districts(@er.enrollments)
  end

  def create_districts(enrollments)
    @districts = enrollments.reduce([]) do |districts, enrollment|
      district = District.new({:name => enrollment.name})
      district.enrollment = enrollment
      districts << district
      districts
    end
  end

  def find_by_name(district_name)
    @districts.find{|district|district.name == district_name.upcase}
  end

  def find_all_matching(district_fragment)
    @districts.find_all{|district|district.name.include?(district_fragment.upcase)}
  end
end
