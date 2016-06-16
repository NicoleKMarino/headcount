require_relative "../lib/district_repository.rb"
require_relative "../lib/enrollment_repository.rb"
require_relative "../lib/economic_profile_repository.rb"
require_relative '../lib/result_formatter'

class HeadcountAnalyst
  include ResultFormatter
  def initialize
    @dr = DistrictRepository.new
    @enrollment=@dr.load_data({:enrollment => {:kindergarten =>'/Users/Nicole/Documents/mod1/headcount/data/kindergartners_in_full_day_program.csv',
      :high_school_graduation => '/Users/Nicole/Documents/mod1/headcount/data/High school graduation rates.csv'}},
      {:statewide_testing => {
        :third_grade => "/Users/Nicole/Documents/mod1/headcount/data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "/Users/Nicole/Documents/mod1/headcount/data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "/Users/Nicole/Documents/mod1/headcount/data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "/Users/Nicole/Documents/mod1/headcount/data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "/Users/Nicole/Documents/mod1/headcount/data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}},
        :economic_profile => {
          :median_household_income => "/Users/Nicole/Documents/mod1/headcount/data/Median household income.csv",
          :children_in_poverty => "/Users/Nicole/Documents/mod1/headcount/data/School-aged children in poverty.csv",
          :free_or_reduced_price_lunch => "/Users/Nicole/Documents/mod1/headcount/data/Students qualifying for free or reduced price lunch.csv",
          :title_i => "/Users/Nicole/Documents/mod1/headcount/data/Title I students.csv"})
        end

        def district(name)
          find_district_average(@dr.find_by_name(name))
        end

        def find_district_average(district)
          average=district.enrollment.kindergarten_participation_by_year.values.reduce(:+) / district.enrollment.kindergarten_participation_by_year.length
        end

        def kindergarten_participation_rate_variation(district_name1, district_name2)
          district1 = district(district_name1)
          district2 = district(district_name2)
          result = district1 / district2
          display_result(result)
        end

        def display_result(result)
          if result < 1
            return "there was no significant change"
          else
            return "There was a significant change"
          end
        end

        def kindergarten_participation_rate_variation_trend(district_name1,district_name2)
          district1 =@dr.find_by_name(district_name1)
          district2 =@dr.find_by_name(district_name2)
          percents1 = district1.enrollment.enrollment_data[:kindergarten_participation]
          percents2= district2.enrollment.enrollment_data[:kindergarten_participation]
          merge_results(percents1,percents2)
        end

        def merge_results(percents1,percents2)
          result = percents1.merge(percents2){|k, a_value, b_value| a_value/b_value }
          answer= result.each do |k, v|
            result[k] = truncate_float(v)
          end
          answer
        end

        def truncate_float(float)
          unless float == nil
            (float * 1000).floor / 1000.to_f
          end
        end

        def graduation_rate_average(district_name)
          district=@dr.find_by_name(district_name)
          all_pp= district.enrollment.graduation_rate_by_year
          result = all_pp.values.reduce(:+) / all_pp.length
        end

        def kindergarten_participation_against_high_school_graduation(district_name)
          result = find_variations(district_name)
        end


        def kindergarten_participation_correlates_with_high_school_graduation(district_name)
          if district_name.include? "STATEWIDE"
            result = statewide_correlation
          elsif district_name.class == Array
            find_variations_of_array(district_name)
          else
            result= find_variations(district_name)
            if (0.6..1.5).cover?(result)
              true
            else
              false
            end
          end
        end

        def statewide_correlation
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

        def find_variations_of_array(district_name)
          correlations=[]
          district_name.each do |district|
            result = kindergarten_participation_correlates_with_high_school_graduation(district)
            correlations.push(result)
          end
          find_percentage(correlations)
        end

        def find_percentage(correlations)
          result = correlations.count("true")/correlations.length.to_f
          percent = result * 100
          if percent >= 70
            return true
          else
            return false
          end
        end

        def find_variations(district_name)
          kindergarten_variation = district(district_name)/district("Colorado")
          hs_variation = graduation_rate_average(district_name) / graduation_rate_average("Colorado")
          result = kindergarten_variation/hs_variation
        end

        def find_statewide_correlation
          correlations = []
          @dr.districts.each do |name, info|
            kindergarten_variation = district(name)/district("Colorado")
            hs_variation = graduation_rate_average(name) / graduation_rate_average("Colorado")
            result = kindergarten_variation / hs_variation
            if (0.6..1.5).cover?(result)
              correlations.push(result)
            end
          end
        end

end
