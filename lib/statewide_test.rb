require_relative 'errors'
require_relative 'proficiency_parser'
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
    parser = ProficiencyParser.new
    if grade == 3
      parser.format_proficiency_by_year(@proficiency_by_district[:third_grade])
    elsif grade == 8
      parser.format_proficiency_by_year(@proficiency_by_district[:eighth_grade])
    else
      raise UnknownDataError, "No known grade in statewide proficiency statistics"
    end
  end

  def proficient_by_ethnicity(race)
    unless @proficiency_by_district[:math][race] == nil
      parser = ProficiencyParser.new
      parser.format_proficiency_by_ethnicity(@proficiency_by_district, race)
    else
      raise UnknownRaceError, "No known race in statewide proficiency statistics"
    end
  end

  def proficient_for_subject_by_race_in_year(subject, ethnicity, year)
    proficient_by_ethnicity(ethnicity)[year][subject]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    proficient_by_grade(grade)[year][subject]
  end

end
