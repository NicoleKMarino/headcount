require 'pry'
require_relative 'enrollment_repository'
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
    @districts = Hash.new
    enrollments.each do |district, enrollment_data|
      district = District.new({:name => enrollment_data.name})
      district.enrollment = enrollment_data
      districts[enrollment_data.name] = district
    end
  end

  def find_by_name(district_name)
   @districts[district_name.upcase]
  end

  def find_all_matching(district_fragment)
    @districts.values.find_all do |dstrct|
      dstrct if dstrct.name.include?(district_fragment.upcase)
    end
  end
end
