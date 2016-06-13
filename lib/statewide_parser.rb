require 'pry'
require 'csv'

module StatewideParser

  def open_csv(filename)
    @filename = filename
    @parsed_data = Hash.new
    contents = CSV.open(filename, headers: true, header_converters: :symbol)
    parse_statewide(contents)
  end

  def parse_statewide(opened_csv)
    opened_csv.each do |row|
      district = row[:location]
      ethnicity = row[:race_ethnicity]
      subject = row[:score]
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      data_by_district = {district => {subject => {year => percent}}}
      merge_statewide_data(data_by_district, subject)
      sort_statewide_tests(district, ethnicity, subject, year, percent)
    end
    binding.pry
    @parsed_data = Hash.new
  end

  def sort_statewide_tests(district, ethnicity, subject, year, percent)
    if ethnicity == nil
      format_grade_test(district, subject, year, percent)
    else
      format_ethnicity_test(district, ethnicity)
    end
  end

  def format_grade_test(district, subject, year, percent)
    if @filename.include?("3rd")
      scores_by_district = {:third_grade => @parsed_data[district]}
    elsif @filename.include?("8th")
      scores_by_district = {:eighth_grade => @parsed_data[district]}
    end
    create_sw_test_by_grade(district, scores_by_district)
  end

  def merge_statewide_data(data_by_district, subject)
    @parsed_data.merge!(data_by_district) do |district, old_data, new_data|
      old_data.merge!(new_data){|s,o,n|o.merge!(n)}
    end
  end

  def format_ethnicity_test(district, ethnicity)
  end
end
