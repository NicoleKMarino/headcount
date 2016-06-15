class EconomicProfileStatisticalParser
  def find_matching_ranges(median_income, year)
    covered_years = median_income.keys.find_all do |range|
      (range.first..range.last).cover?(year)
    end
    validity_check(median_income, covered_years)
  end

  def validity_check(median_income, covered_years)
    unless covered_years.flatten.empty?
      find_average_income(median_income, covered_years)
    else
      error
    end
  end

  def find_average_income(median_income, covered_years)
    covered_years.reduce([]) do |incomes, range|
      incomes << median_income[range]
    end.reduce(:+) / covered_years.count
  end

  def find_children_in_poverty(children_in_poverty, year)
    unless children_in_poverty[year] == nil
      truncate_float(children_in_poverty[year])
    else
      error
    end
  end

  def find_free_or_reduced_lunch_percentage(free_or_reduced_lunch, year)
    unless free_or_reduced_lunch[year] == nil
      truncate_float(free_or_reduced_lunch[year][:percentage])
    else
      error
    end
  end

  def find_free_or_reduced_lunch_number(free_or_reduced_lunch, year)
    unless free_or_reduced_lunch[year] == nil
      truncate_float(free_or_reduced_lunch[year][:total])
    else
      error
    end
  end

  def find_title_i_in_year(title_i, year)
    unless title_i[year] == nil
      truncate_float(title_i[year])
    else
      error
    end
  end

  def error
    raise UnknownDataError, "Year not included in district economic data."
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f unless float == nil
  end
end
