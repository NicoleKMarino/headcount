require 'pry'
require_relative './District/district_repository'

class HeadcountAnalyst
  def initialize
    @dr = DistrictRepository.new
  end

  def load_data
    @enrollment = @dr.load_data({:enrollment => {:kindergarten => './data/kindergartners_in_full_day_program.csv'}})
  end
end
