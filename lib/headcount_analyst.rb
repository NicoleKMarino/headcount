class HeadcountAnalyst
  def initialize(district_repo)
    @dr= district_repo
  end


  def kindergarten_participation_rate_variation(district1,district2)
    result = #the result of the district average divided by state average. (i.e. find the districts average participation across all years and divide it by the average of the state participation data across all years.)
    if result > 1
      puts "there was no significant change"
    else
      puts "There was a significant change"
  end

end
