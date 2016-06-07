require "csv"
require 'pry'
require "/Users/Nicole/Documents/mod1/headcount/lib/District/district.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/parser.rb"

class DistrictRepository
  def initialize(data)
    @repos = []
    parser
  end

  def parser
    Parser.new
    Parser.#methods to get back info
  end 

  def load_data
    contents = CSV.open './data/Kindergartners in full-day program.csv', headers: true, header_converters: :symbol
    contents.each do |row|
      district = row[:location]
      year = row[:timeframe]
      percent = row[:data]
      if find_by_name(district) == nil
        @repos << District.new({:name => district]})
      else
        puts "test"
      end
    end
  end


  def find_by_name(name)
    @repos.each do |district|
      if district.name == name.upcase
        puts "That is in there"
        return district
      else
        return nil
      end
    end
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


  def enrollment
    EnrollmentRepository.new
  end

end
