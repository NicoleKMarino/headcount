require "/Users/Nicole/Documents/mod1/headcount/lib/district_repository.rb"
require "/Users/Nicole/Documents/mod1/headcount/lib/enrollment_repository.rb"

class HeadcountAnalyst
  def initialize
    @dr = DistrictRepository.new
    @enrollment= @dr.load_data({:enrollment => {:kindergarten =>'/Users/Nicole/Documents/mod1/headcount/data/kindergartners_in_full_day_program.csv', :high_school_graduation => '/Users/Nicole/Documents/mod1/headcount/data/High school graduation rates.csv'}})
  end

  def district(name)
    find_district_average(@dr.find_by_name(name))
  end

  def find_district_average(district)
    district.enrollment.kindergarten_participation_by_year.values.reduce(:+) / district.enrollment.kindergarten_participation_by_year.length
  end

  def kindergarten_participation_rate_variation(district_name1, district_name2)
    district1 = district(district_name1)
    district2 = district(district_name2)
    result = district1 / district2
    display_result(result)
  end

  def display_result(result)
    if result < 1
      puts "there was no significant change"
    else
      puts "There was a significant change"
    end
  end


  def kindergarten_participation_rate_variation_trend(district_name1,district_name2)
    district1 =@dr.find_by_name(district_name1)
    district2 =@dr.find_by_name(district_name2)
    percents1 = district1.enrollment.enrollment_data_by_district[:kindergarten_participation]
    percents2= district2.enrollment.enrollment_data_by_district[:kindergarten_participation]
    result = percents1.merge(percents2){|k, a_value, b_value| a_value/b_value }
    answer= result.each do |k, v|
    result[k] = truncate_float(v)
  end
end

def truncate_float(float)
  unless float == nil
    (float * 1000).floor / 1000.to_f
  end
end


def graduation_rate_by_year(district_name)
  district = @dr.find_by_name(district_name)
  @dr = district
  district.enrollment.graduation_rate_by_year
end

def graduation_rate_in_year(year)
  rates = @dr.enrollment.graduation_rate_by_year
  rates.each do |key,value|
    if key.to_i == year
      return value
    else
      nil
    end
  end
end

def graduation_rate_average(district_name)
  district=@dr.find_by_name(district_name)
  all_pp= district.enrollment.graduation_rate_by_year
  all_pp.values.reduce(:+) / all_pp.length
end

def kindergarten_participation_against_high_school_graduation(district_name)
  result = find_variations(district_name)
  if result.round == 1
    puts "There was a significant correlation"
  else
    puts "There wasn't a significant correlation"
  end
end

def find_statewide_correlation
  correlations=[]
  @dr.districts.each do |name,info|
    result = find_variations(name)
    if (0.6..1.5).cover?(result)
      correlations.push("true")
    else
      correlations.push("false")
    end
  end
  find_percentage(correlations)
end


def find_percentage(correlations)
  result = correlations.count("true")/correlations.length.to_f
  percent = result * 100
  if percent > 70
    return true
  else
    return false
  end
end

def kindergarten_participation_correlates_with_high_school_graduation(district_name)
  if district_name.include? "STATEWIDE"
    find_statewide_correlation
  elsif district_name.class == Array
    find_variations_of_array(district_name)
  else
    result=find_variations(district_name)
    if (0.6..1.5).cover?(result)
      return true
    else
      return false
    end
  end
end

def find_variations_of_array(district_name)
  correlations=[]
  district_name.each do |district|
    result = kindergarten_participation_correlates_with_high_school_graduation(district)
    correlations.push(result)
  end
  find_percentage(correlations)
end

def find_variations(district_name)
  kindergarten_variation= district(district_name) / district("Colorado")
  hs_variation=graduation_rate_average(district_name) / graduation_rate_average("Colorado")
  result= kindergarten_variation/hs_variation
end

end

ha=HeadcountAnalyst.new
ha.kindergarten_participation_rate_variation_trend('ACADEMY 20','Colorado')
