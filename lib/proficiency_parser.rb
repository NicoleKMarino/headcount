class ProficiencyParser

  def format_proficiency_by_ethnicity(proficiency, race)
    math = {:math => proficiency[:math][race]}
    reading = {:reading => proficiency[:reading][race]}
    writing = {:writing => proficiency[:writing][race]}
    format_proficiency_by_year(math.merge(reading.merge(writing)))
  end

  def format_proficiency_by_year(data)
    formatted_by_year = data.values.reduce do |subject1,subject2|
      subject1.sort.zip(subject2.sort)
    end.map{|subject|subject.flatten}.map{|row|row.uniq}
    sort_grade_proficiency_by_year(formatted_by_year, data)
  end

  def sort_grade_proficiency_by_year(formatted_by_year, aggregated_data)
    sorted_years = formatted_by_year.group_by{|row|row.shift}
    sort_by_subject(sorted_years, aggregated_data)
  end

  def sort_by_subject(sorted_years, data)
    sorted_by_subject = sorted_years.reduce({}) do |result, scores|
      result.merge!({scores.first => data.keys.zip(scores.last.flatten.map do |percent|
        truncate_float(percent)
      end).to_h})
    end
  end
    
  def truncate_float(float)
    (float * 1000).floor / 1000.to_f unless float == nil
  end
end
