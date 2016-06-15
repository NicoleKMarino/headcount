require 'pry'
require_relative 'enrollment'
require 'csv'

module EnrollmentParser

  def sort_enrollment_request(kindergarten_file, hs_graduation_file)
    open_csv(kindergarten_file) unless kindergarten_file == nil
    open_csv(hs_graduation_file) unless hs_graduation_file == nil
  end

  def open_csv(filename)
    @filename = filename
    @parsed_data = Hash.new
    contents = CSV.open(filename, headers: true, header_converters: :symbol)
    parse_enrollments(contents)
  end

  def parse_enrollments(opened_csv)
    opened_csv.each do |row|
      district = row[:location]
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      data_by_school = {district => {year => percent}}
      merge_data(data_by_school)
      sort_enrollment(district)
    end
  end

  def merge_data(district_info)
    @parsed_data.merge!(district_info) do |district, old_ptcpn, new_ptcpn|
      old_ptcpn.merge!(new_ptcpn)
    end
  end

  def sort_enrollment(district_name)
    if @filename.include?("kindergartners")
      enrollment_specs = {:name => district_name, :kindergarten_participation => @parsed_data[district_name].sort.to_h}
    elsif @filename.include?("High school")
      enrollment_specs = {:name => district_name, :high_school_graduation => @parsed_data[district_name].sort.to_h}
    end
    create_enrollment(district_name, enrollment_specs)
  end
end
