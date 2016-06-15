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
    ep = new_economic_profile(district)
    unless @economic_profiles[district] == nil
      @economic_profiles[district].append_economic_data(ep[district])
    else
      add_economic_profile(ep)
    end
  end

  def new_economic_profile(district)
    {district => EconomicProfile.new(economic_profile_data(district))}
  end

  def economic_profile_data(district)
    @parsed_data[district].merge!({:name => district})
  end

  def add_economic_profile(new_economic_profile)
    @economic_profiles.merge!(new_economic_profile)
  end

  def find_by_name(district)
    @economic_profiles[district]
  end
end
