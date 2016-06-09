class District
  attr_reader :name
  attr_accessor :enrollment
  def initialize(name_hash)
    @name = name_hash[:name]
    @enrollment = nil
  end
end
