require 'pry'
require_relative 'result_entry'

class ResultSet
  attr_accessor :matching_districts, :statewide_average
  def initialize(appropriate_districts)
    @matching_districts = appropriate_districts[:matching_districts]
    @statewide_average = appropriate_districts[:statewide_average]
  end
end
