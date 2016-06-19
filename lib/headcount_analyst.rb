require_relative "../lib/district_repository.rb"
require_relative "../lib/enrollment_repository.rb"
require_relative "../lib/economic_profile_repository.rb"
require_relative '../lib/result_formatter'

class HeadcountAnalyst
  include ResultFormatter
  def initialize(dr)
    @dr = dr
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
          puts results
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
