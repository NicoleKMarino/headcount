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
    if district_name.class == Hash
      sort_request(district_name)
    else
      @districts[district_name]
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
