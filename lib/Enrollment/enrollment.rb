require 'pry'

class Enrollment
  attr_reader :name
  def initialize(hash_thing)
    @hash_thing = hash_thing
    @sorted_enrollments = Hash.new
    @name = hash_thing[:name]
    format_args
  end

  def format_args
    @hash_thing[:kindergarten_participation].each do |key,value|
      @sorted_enrollments[key] = truncate_float(value)
    end
  end

  def kindergarten_participation_by_year
    @sorted_enrollments
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f
  end


  def kindergarten_participation_in_year(year)
    @sorted_enrollments[year]
  end

end
