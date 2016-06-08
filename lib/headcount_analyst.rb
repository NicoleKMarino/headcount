class HeadcountAnalyst
  def initialize(district_repo)
    @dr= district_repo
  end

  def find_district_average(district)
    array=[]
    district.percentage.each do |percents|
      array << percents
    end
    array.reduce(:+) / array.length
    #may not have to push it into seperate array, look up ruby way
  end

  def kindergarten_participation_rate_variation(district1,district2)
    district1 = find_district_average(district1)
    district2 = find_district_average(district2)
    result = district1 / district2
    if result > 1
      puts "there was no significant change"
    else
      puts "There was a significant change"
  end

  def kindergarten_participation_rate_variation_trend
  end


end
