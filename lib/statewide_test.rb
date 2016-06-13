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
      data = @proficiency_by_district[:third_grade]
    end
      format_by_year(data)
  end

  def format_by_year(data)
    formatted_by_year = data.values.reduce do |subject1,subject2|
      subject1.sort.zip(subject2.sort)
    end.map{|year|year.flatten}.map{|row|row.uniq!}
    sort_by_subject(formatted_by_year, data)
  end

  def sort_by_subject(formatted_by_year, data)
    sorted_years = formatted_by_year.group_by{|row|row.shift}
    sorted_by_subject = sorted_years.reduce({}) do |result, scores|
      result.merge!({scores.first => data.keys.zip(scores.last.flatten.map do |percent|
        truncate_float(percent)
      end).to_h})
    end
    binding.pry
  end

  def truncate_float(float)
    (float * 1000).floor / 1000.to_f unless float == nil
  end
end
