require 'pry'
require_relative 'enrollment'
require 'csv'

module EnrollmentParser

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
    binding.pry
  end

  def merge_data(district_info)
    @parsed_data.merge!(district_info) do |district, old_ptcpn, new_ptcpn|
      old_ptcpn.merge!(new_ptcpn)
    end
  end

  def sort_enrollment(district_name)
    if @filename.include?("Kindergartners")
      create_kindergarten_enrollment(district_name)
    elsif @filename.include?("High school")
      create_graduation_enrollment(district_name)
    end
  end
end
