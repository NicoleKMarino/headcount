require 'pry'

class StatewideTest
  attr_reader :proficiency_by_district
  def initialize(proficiency_by_district)
    @proficiency_by_district = proficiency_by_district
  end

  def append_new_data(conflicting_district)
    @proficiency_by_district.merge!(conflicting_district.proficiency_by_district)
  end
end
