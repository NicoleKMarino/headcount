require_relative 'errors'
require_relative 'proficiency_parser'
require 'pry'

class StatewideTest
  attr_reader :proficiency
  attr_accessor :name
  def initialize(proficiency_by_district)
    @proficiency = proficiency_by_district
  end

  def append_new_data(conflicting_district)
    @proficiency.merge!(conflicting_district.proficiency)
  end

  def proficient_by_grade(grade)
    parser = ProficiencyParser.new
    if grade == 3
      parser.format_proficiency_by_year(@proficiency[:third_grade])
    elsif grade == 8
      parser.format_proficiency_by_year(@proficiency[:eighth_grade])
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    unless @proficiency[:math][race] == nil
      parser = ProficiencyParser.new
      parser.format_proficiency_by_ethnicity(@proficiency, race)
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, ethnicity, year)
    subject_inspect(subject)
    score = proficient_by_race_or_ethnicity(ethnicity)[year][subject]
    if score == nil
      "N/A"
    else
      score
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    subject_inspect(subject)
    score = proficient_by_grade(grade)[year][subject]
    if score == nil
      "N/A"
    else
      score
    end
  end

  def subject_inspect(subject)
    unless [:math, :reading, :writing].any?{|sub|sub==subject}
      proficient_by_grade(1)
    end
  end

end
