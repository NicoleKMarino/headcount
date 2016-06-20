require_relative '../lib/result_set'
require_relative '../lib/result_entry'
require_relative "../lib/district_repository"
require_relative "../lib/enrollment_repository"
require_relative "../lib/economic_profile_repository"
require_relative '../lib/result_formatter'

class HeadcountAnalyst
  include ResultFormatter
  attr_reader :rs, :state
  def initialize(dr)
    @dr = dr
  end
end
