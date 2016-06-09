

class District
  def initialize(district_hash)
    @name = district_hash[:name]
    @enrollment = district_hash[:enrollment]
  end

  def name
    @name.upcase
  end


end
