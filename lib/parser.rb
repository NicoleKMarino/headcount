require './lib/Enrollment/enrollment'
require 'csv'
require 'pry'

module Parser

  def open_csv(filename)
    contents = CSV.open(filename, headers: true, header_converters: :symbol)
    parse_contents(contents)
  end

  def parse_contents(opened_csv)
    opened_csv.each do |row|
      district = row[:location]
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      data_by_school = {district => {year => percent}}
      merge_data(data_by_school)
      format_enrollment_hash(district)
    end
  end

  def merge_data(district_info)
    @parsed_data.merge!(district_info) do |district, old_ptcpn, new_ptcpn|
      old_ptcpn.merge!(new_ptcpn)
    end
  end

  def format_enrollment_hash(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :kindergarten_participation => @parsed_data[district_name].sort.to_h})}
    @enrollments.merge!(new_enrollment)
  end
end
