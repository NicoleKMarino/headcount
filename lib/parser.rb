require 'csv'
require 'pry'

class Parser
  def initialize
    @filename = "./data/kindergartners_in_full_day_program.csv"
    @parsed_data = Array.new
    @participation = Hash.new
  end

  def open_csv
    contents = CSV.open(@filename, headers: true, header_converters: :symbol)
    parse_contents(contents)
  end

  def parse_contents(opened_csv)
    opened_csv.each do |row|
      @district = row[:location]
      @year = row[:timeframe].to_i
      @percent = row[:data].to_f
      @participation.merge(participation_sort)
      agg_data = [@district,@participation]
      
      @parsed_data << agg_data.group_by{@district}
    end
    binding.pry
  end

  def participation_sort
    @participation[@year] = @percent.to_f
    @participation
  end

end
parser = Parser.new
parser.open_csv
