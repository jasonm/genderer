require 'rubygems'
require 'amatch'
require 'census_file_name_frequencies'

class Genderer
  MINIMUM_JARO_WINKLER_MATCH_DISTANCE = 0.75

  attr_accessor :name_frequency_provider

  def initialize(name_frequencies)
    @female_frequencies = name_frequencies["female"]
    @male_frequencies = name_frequencies["male"]
  end

  def gender_for(name)
    name = name.upcase

    female_score = score_gender_by(@female_frequencies, name)
    male_score   = score_gender_by(@male_frequencies, name)

    if female_score == male_score
      'Unknown'
    elsif female_score > male_score
      'F'
    else
      'M'
    end
  end

  private

  def score_gender_by(hash, name)
    score = frequency_by(hash, name)
    if score.zero?
      closest_name, match_factor = best_match_and_factor_in(hash.keys, name)
      match_factor = 0 if match_factor < MINIMUM_JARO_WINKLER_MATCH_DISTANCE
      score = frequency_by(hash, closest_name) * match_factor
    end
    score
  end

  def frequency_by(hash, name)
    name = name.upcase
    hash[name] || 0
  end

  def best_match_and_factor_in(list, item)
    matcher = Amatch::JaroWinkler.new(item)
    matcher.ignore_case = true
    weights = matcher.match(list)
    best_match_weight = weights.max
    best_match_index = weights.index(best_match_weight)

    [list[best_match_index], best_match_weight]
  end
end

