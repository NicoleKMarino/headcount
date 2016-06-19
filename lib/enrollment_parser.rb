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

  def sort_enrollment(district)
    if @filename.include?("Kindergartners")
      enrollment_specs = kindergarten_spec(district)
    elsif @filename.include?("High school")
      enrollment_specs = graduation_spec(district)
    end
    create_enrollment(district, enrollment_specs)
  end

  def kindergarten_spec(district)
   {:name => district, :kindergarten => format_instance(district)}
  end

  def graduation_spec(district)
    {:name => district, :high_school_graduation => format_instance(district)}
  end

  def format_instance(district)
    @parsed_data[district].sort.to_h
  end
end
