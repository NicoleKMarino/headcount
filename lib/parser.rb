require_relative 'enrollment'
require 'csv'

module Parser

  def open_csv(filename)
    @filename = filename
    @parsed_data = Hash.new
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
      sort_enrollment(district)
    end
  end

  def merge_data(district_info)
    @parsed_data.merge!(district_info) do |district, old_ptcpn, new_ptcpn|
      old_ptcpn.merge!(new_ptcpn)
    end
  end

  def sort_enrollment(district_name)
    if @filename.include?("Kindergartners")
      format_kindergarten_enrollment(district_name)
    elsif @filename.include?("High school")
      format_graduation_enrollment(district_name)
    end
  end
  
  def format_kindergarten_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :kindergarten_participation => @parsed_data[district_name].sort.to_h})}
    add_enrollment(new_enrollment)
  end

  def format_graduation_enrollment(district_name)
    new_enrollment = {district_name => Enrollment.new({:name => district_name, :high_school_graduation => @parsed_data[district_name].sort.to_h})}
    unless @enrollments[district_name] == nil
      @enrollments[district_name].append_enrollment_data(new_enrollment[district_name])
    else
      add_enrollment(new_enrollment)
    end
  end

  def add_enrollment(new_enrollment)
    @enrollments.merge!(new_enrollment)
  end
end
