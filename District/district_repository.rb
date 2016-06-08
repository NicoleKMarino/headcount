require "csv"
require 'pry'
require "/Users/Nicole/Documents/mod1/headcount/lib/District/district.rb"

class DistrictRepository
  def initialize(file)
    @repos = []
    contents = CSV.open file, headers: true, header_converters: :symbol
    contents.map do |row|
      if find_by_name(row[:location]) != nil
        @repos << District.new({:name => row[:location]})
      else
        # figure out what to put in here
      end
    end
  end


  def find_by_name(name)
    @repos.each do |district|
      if district.name == name.upcase
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

end
