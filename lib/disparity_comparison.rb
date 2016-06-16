

class DisparityComparison
  def initialize(name)
    @dr = 
    start(name)
  end

  def start(name)
    @dr.districts.each do |district|
      format_results(district) if poverty?(district)
  end

end
