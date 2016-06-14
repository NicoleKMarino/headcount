class EconomicProfile
  attr_reader :economic_data_by_district
  def initialize(economic_data)
    @economic_data_by_district = economic_data
  end

  def append_economic_data(conflicting_district)
    @economic_data_by_district.merge!(conflicting_district.economic_data_by_district)
  end
end
