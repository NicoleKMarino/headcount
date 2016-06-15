require 'pry'
class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test, :economic_profile
  def initialize(district_hash)
    @name = district_hash[:name]
  end
end
