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
      data_by_school = [district,year,percent]
      format_check(data_by_school) unless @parsed_data.empty?
      @parsed_data << data_by_school
    end
    participation_format(aggregate_district_data)
    @enrollments.sort_by!{|enrollment|enrollment.name}
  end

  def format_check(row_data)
    if @parsed_data.last.first != row_data.first
      participation_format(aggregate_district_data)
    end
  end

  def aggregate_district_data
    @parsed_data.find_all{|r|r.first == @parsed_data.last.first}
  end

  def participation_format(compiled_data_by_school)
    participation_by_school = compiled_data_by_school.reduce({}) do |result,school_data|
      result[school_data[1]] = school_data.last
      result
    end
    format_enrollment_hash(participation_by_school, compiled_data_by_school.first.first)
  end

  def format_enrollment_hash(nested_participation_hash, district_name)
    if @enrollments.any?{|enrollment|enrollment.name == district_name}
      @enrollments.reject!{|enrollment|enrollment.name == district_name}
    end
    @enrollments << Enrollment.new({:name => @parsed_data.last.first, :kindergarten_participation => nested_participation_hash.sort.to_h})
  end
end
