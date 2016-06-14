require_relative 'economic_profile'
require_relative 'economic_profile_parser'
class EconomicProfileRepository
  include EconomicProfileParser
  attr_reader :economic_profiles
  def initialize
    @economic_profiles = Hash.new
  end

  def load_data(ugly_hash)
    assert_files(ugly_hash.dig(:economic_profile))
  end

  def create_economic_profile(district)
    new_economic_profile = {district => EconomicProfile.new(@parsed_data[district])}
    unless @economic_profiles[district] == nil
      @economic_profiles[district].append_economic_data(new_economic_profile[district])
    else
      add_economic_profile(new_economic_profile)
    end
  end

  def add_economic_profile(new_economic_profile)
    @economic_profiles.merge!(new_economic_profile)
  end
end
