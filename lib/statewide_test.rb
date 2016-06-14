require 'pry'

class StatewideTest
  attr_reader :proficiency_by_district
  def initialize(proficiency_by_district)
    @proficiency_by_district = proficiency_by_district
  end

  def append_new_data(conflicting_district)
    @proficiency_by_district.merge!(conflicting_district.proficiency_by_district)
  end

  def proficient_by_grade(grade)
    if grade == 3
      raw_data = @proficiency_by_district[:third_grade]
      format_proficiency_by_year(raw_data)
    elsif grade == 8
      raw_data = @proficiency_by_district[:eighth_grade]
      format_proficiency_by_year(raw_data)
    else
      raise UnknownDataError
    end
  end

  def proficient_by_ethnicity(race)
    math = {:math => @proficiency_by_district[:math][race]}
    reading = {:reading => @proficiency_by_district[:reading][race]}
    writing = {:writing => @proficiency_by_district[:writing][race]}
    format_proficiency_by_year(math.merge(reading.merge(writing)))
  end

  def proficient_for_subject_by_race_in_year(subject, ethnicity, year)
    proficient_by_ethnicity(ethnicity)[year][subject]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    proficient_by_grade(grade)[year][subject]
  end

  def format_proficiency_by_year(data)
    formatted_by_year = data.values.reduce do |subject1,subject2|
      subject1.sort.zip(subject2.sort)
    end.map{|year|year.flatten}.map{|row|row.uniq!}
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
