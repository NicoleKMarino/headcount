
require "/Users/Nicole/Documents/mod1/headcount/lib/enrollment.rb"
require 'csv'
require 'pry'


module Parser

  def sort_request(kindergarten_file, hs_graduation_file)
    open_csv(kindergarten_file) unless kindergarten_file == nil
    open_csv(hs_graduation_file) unless hs_graduation_file == nil
  end

  def open_csv(filename)
    @filename = filename
    @parsed_data = Hash.new
    contents = CSV.open(filename, headers: true, header_converters: :symbol)
    if @filename.include?("proficien")
      parse_statewide(contents)
    else
      parse_enrollments(contents)
    end
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
    if @filename.include?('kindergartners')
      create_kindergarten_enrollment(district_name)
    elsif @filename.include?('High school')
      create_graduation_enrollment(district_name)
    end
  end
end
