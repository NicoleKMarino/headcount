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
    parse_economic_data(contents)
  end

  def parse_economic_data(economic_contents)
    economic_contents.each do |row|
      district = row[:location]
      year = row[:timeframe]
      household_income?(district, year, row[:data])
      children_in_poverty?(district, year, row[:dataformat], row[:data])
      lunch?(district, year, row[:data], row[:dataformat], row[:poverty_level])
      title_i?(district, year, row[:data])
    end
  end

  def household_income?(district, year, data)
   if @filename.include?("household")
    format_household_income(district, year, data)
   end
  end

  def format_household_income(district, year, data)
    merge_economic_information(household_income(district, year, data))
    create_economic_profile(district)
  end

  def household_income(district, year, data)
    {district => {:median_household_income => income_adjustment(year, data)}} 
  end

  def income_adjustment(year, data)
    {year.split("-").map(&:to_i) => data.to_i}
  end

  def children_in_poverty?(district, year, data_format, data)
   if @filename.include?("poverty") && data.to_f < 1
    format_children_in_poverty(district, year, data_format, data)
   end
  end

  def format_children_in_poverty(district, year, data_format, data)
    poverty_data = children_in_poverty(district, year, data_format, data)
    merge_economic_information(poverty_data)
    create_economic_profile(district)
  end

  def children_in_poverty(district, year, data_format, data)
    {district => {:children_in_poverty => {year.to_i => data.to_f}}}
  end

  def lunch?(district, year, data, data_format, lunch_eligibility)
   unless lunch_eligibility == nil
    format_lunch_data(district, year, data, data_format, lunch_eligibility)
   end
  end

  def format_lunch_data(district, year, data, data_format, lunch_eligibility)
    if data_format == "Percent"
      lunch_data = lunch_percentage(district, year, data, lunch_eligibility)
    elsif data_format == "Number"
      lunch_data = lunch_total(district, year, data, lunch_eligibility)
    end
    merge_lunch_eligibility(lunch_data)
    create_economic_profile(district)
  end

  def lunch_percentage(district, year, data, lunch)
    {district => {lunch_key(lunch)=> {year.to_i => {:percentage => data.to_f}}}}
  end 

  def lunch_total(district, year, data, lunch)
    {district => {lunch_key(lunch) => {year.to_i => {:total => data.to_i}}}}
  end

  def lunch_key(lunch_eligibility)
    lunch_eligibility.split.join("_").downcase.to_sym
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
    @parsed_data.merge!(data_by_lunch) do |district, old_lunch, new_lunch|
      super_lunch_merge(old_lunch, new_lunch)
    end
  end

  def super_lunch_merge(old_lunch, new)
    old_lunch.merge!(new){|s,o,n|o.merge!(n){|s,o,n|o.merge!(n)}.sort.to_h}
  end
end
