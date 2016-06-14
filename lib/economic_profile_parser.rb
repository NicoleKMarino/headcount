require 'pry'
require 'csv'

module EconomicProfileParser

  def assert_files(economic_profile_files)
    valid_files = Array.new
    valid_files << economic_profile_files.dig(:median_household_income)
    valid_files << economic_profile_files.dig(:children_in_poverty)
    valid_files << economic_profile_files.dig(:free_or_reduced_price_lunch)
    valid_files << economic_profile_files.dig(:title_i)
    assert_valid_requests(valid_files)
  end

  def assert_valid_requests(valid_files)
    valid_files.each do |file|
      open_csv(file) unless file == nil
    end
  end

  def open_csv(file)
    @filename = file
    @parsed_data = Hash.new
    contents = CSV.open(file, headers: true, header_converters: :symbol)
    parse_statewide_data(contents)
  end

  def parse_statewide_data(statewide_contents)
    statewide_contents.each do |row|
      district = row[:location]
      year = row[:timeframe]
      data_format = row[:dataformat]
      data = row[:data]
      lunch_eligibility = row[:poverty_level]
      household_income?(district, year, data)
      children_in_poverty?(district, year, data_format, data)
      lunch_eligibility?(district, year, data, data_format, lunch_eligibility)
      title_i?(district, year, data)
    end
    binding.pry
  end

  def household_income?(district, year, data)
    format_household_income(district, year, data) if @filename.include?("household")
  end

  def format_household_income(district, year, data)
    income = {district => {:median_household_income => {year.split("-").map(&:to_i) => data.to_f}}} 
    merge_economic_information(income)
    create_economic_profile(district)
  end

  def children_in_poverty?(district, year, data_format, data)
    format_children_in_poverty(district, year, data_format, data) if @filename.include?("poverty") && data.to_f < 1
  end

  def format_children_in_poverty(district, year, data_format, data)
    merge_economic_information({district => {:children_in_poverty => {year.to_i => data.to_f}}})
    create_economic_profile(district)
  end

  def lunch_eligibility?(district, year, data, data_format, lunch_eligibility)
    format_lunch_data(district, year, data, data_format, lunch_eligibility) unless lunch_eligibility == nil
  end

  def format_lunch_data(district, year, data, data_format, lunch_eligibility)
    if data_format == "Percent"
      lunch_data = {district => {lunch_eligibility.split.join("_").downcase.to_sym => {year.to_i => {:percentage => data.to_f}}}}
    elsif data_format == "Number"
      lunch_data = {district => {lunch_eligibility.split.join("_").downcase.to_sym => {year.to_i => {:total => data.to_i}}}}
    end
    merge_lunch_eligibility(lunch_data)
    create_economic_profile(district)
  end

  def title_i?(district, year, data)
    format_title_i_data(district, year, data) if @filename.include?("Title")
  end

  def format_title_i_data(district, year, data)
    title_data = {district => {:title_i => {year.to_i => data.to_f}}} 
    merge_economic_information(title_data)
    create_economic_profile(district)
  end

  def merge_economic_information(data_by_district)
    @parsed_data.merge!(data_by_district) do |district, old_data, new_data|
      old_data.merge!(new_data){|s,o,n|o.merge!(n)}.sort.to_h
    end
  end

  def merge_lunch_eligibility(data_by_lunch)
    @parsed_data.merge!(data_by_lunch) do |district, old_data, new_data|
      old_data.merge!(new_data){|s,o,n|o.merge!(n){|s,o,n|o.merge!(n)}.sort.to_h}
    end
  end
end
