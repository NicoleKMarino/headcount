require 'csv'
require 'pry'

class Parser
  def initialize
    @filename = "./data/kindergartners_in_full_day_program.csv"
    @parsed_data = Array.new
  end

  def open_csv
    contents = CSV.open(@filename, headers: true, header_converters: :symbol)
    parse_contents(contents)
  end

  def parse_contents(opened_csv)
    opened_csv.each do |row|
      district = row[:location]
      year = row[:timeframe].to_i
      percent = row[:data].to_f
      agg_data = [district,year,percent]
      format_check(agg_data) unless @parsed_data.empty?
      @parsed_data << agg_data
    end
  end

  def format_check(row_data)
    unless @parsed_data.last.first == row_data.first 
      #do something
      participation_format(@parsed_data.find_all{|r|r.first == @parsed_data.last.first})
    end
  end

  def participation_format(compiled_data_by_school)
    #AGGREGATE MATCHING SCORES
    # Passing nested participation hash as arg
    participation_by_school = compiled_data_by_school.reduce({}) do |result,school_data|
      result[school_data[1]] = school_data.last
      result
    end
    format_enrollment_hash(participation_by_school)
  end

  def format_enrollment_hash(nested_participation_hash)
    binding.pry
    #CREATE FINAL ARGS FOR ENROLLMENT OBJ
    {:name => @parsed_data.last.first, :kindergarten_participation => nested_participation_hash}
  end

end
parser = Parser.new
parser.open_csv
