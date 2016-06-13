require 'pry'
class District
  attr_reader :name
  attr_accessor :enrollment
  def initialize(district_hash)
    @name = district_hash[:name].upcase
  end

end
