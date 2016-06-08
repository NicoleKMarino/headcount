require "csv"
require 'pry'
require "/Users/Nicole/Documents/mod1/headcount/lib/District/district.rb"
# require "/Users/Nicole/Documents/mod1/headcount/parser.rb"

class DistrictRepository
  # def initialize(data)
  def initialize
    @repos = []
    # parser
  end

  # def parser
  #   Parser.new
  #   Parser.#methods to get back info
  # end

  def load_data
    contents = CSV.open'/Users/Nicole/Documents/mod1/headcount/data/Kindergartners in full-day program.csv', headers: true, header_converters: :symbol
    contents.each do |row|
      district_name = row[:location]
      year = row[:timeframe]
      percent = row[:data]
      if find_by_name(district_name).nil?
        @repos << District.new({:name => district_name})
      else
        puts ""
      end
    end
  end


  def find_by_name(name)
    @repos.each do |district|
      if district.name == name.upcase
        return district
      end
    end
    return nil
  end

  def find_all_matching(input)
    matches=[]
    @repos.each do |district|
      district.name.include?(input)
      if true
        matches << district
      end
    end
  end

  #
  # def enrollment
  #   EnrollmentRepository.new
  # end

end
