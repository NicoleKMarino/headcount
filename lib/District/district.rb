require "csv"


class District
  def initialize(district_hash)
    @name = district_hash[:name]
  end

  def name
    return @name.upcase
  end

  
end
