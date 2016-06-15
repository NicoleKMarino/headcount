require 'pry'
require 'csv'

module StatewideParser

  def assert_files(statewide_hash)
    statewide_testing = statewide_hash.dig(:statewide_testing)
    valid_tests = Array.new
    valid_tests << statewide_testing.dig(:third_grade)
    valid_tests << statewide_testing.dig(:eighth_grade)
    valid_tests << statewide_testing.dig(:math)
    valid_tests << statewide_testing.dig(:reading)
    valid_tests << statewide_testing.dig(:writing)
    load_requests(valid_tests)
  end

  def load_requests(tests)
    tests.each do |test|
      open_csv(test) unless test == nil
    end
  end

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
      sort_statewide_tests(district, ethnicity, subject, year, percent)
    end
  end

  def sort_statewide_tests(district, ethnicity, subject, year, percent)
    if ethnicity == nil
      subject_data = format_subjects(district, subject, year, percent)
      merge_statewide_data(subject_data)
      format_grade_test(district)
    else
      ethnic_data = format_ethnic_categories(district, ethnicity, year, percent)
      merge_statewide_data(ethnic_data)
      format_ethnicity_test(district)
    end
  end

  def format_subjects(district, subject, year, percent)
    {district => {subject.downcase.to_sym => {year => percent}}}
  end

  def format_ethnic_categories(district, ethnicity, year, percent)
    {district => {ethnicity_key_format(ethnicity) => {year => percent}}}
  end

  def ethnicity_key_format(ethnicity)
    ethnicity.gsub(" ","_").split("/").last.downcase.to_sym
  end

  def merge_statewide_data(data_by_district)
    @parsed_data.merge!(data_by_district) do |district, old_data, new_data|
      old_data.merge!(new_data){|s,o,n|o.merge!(n)}
    end
  end

  def format_grade_test(district)
    if @filename.include?("3rd")
      scores_by_district = {:third_grade => @parsed_data[district]}
    elsif @filename.include?("8th")
      scores_by_district = {:eighth_grade => @parsed_data[district]}
    end
    create_sw_test(district, scores_by_district)
  end

  def format_ethnicity_test(district)
    if @filename.include?("Math")
      scores_by_district = {:math => @parsed_data[district]}
    elsif @filename.include?("Reading")
      scores_by_district = {:reading => @parsed_data[district]}
    elsif @filename.include?("Writing")
      scores_by_district = {:writing => @parsed_data[district]}
    end
    create_sw_test(district, scores_by_district)
  end
end
