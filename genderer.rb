require 'rubygems'
require 'amatch'

module CensusFileNameFrequencies
  def self.gender_hashes
    {
      "male" => hash_from_file_for("male"),
      "female" => hash_from_file_for("female")
    }
  end

  private

  def self.hash_from_file_for(gender)
    hash = {}

    lines = open("dist.#{gender}.first").readlines.each do |line|
      name = line.split[0].upcase
      frequency = line.split[1].to_f
      hash[name] = frequency
    end

    hash
  end
end

class Genderer

  MINIMUM_JARO_WINKLER_MATCH_DISTANCE = 0.75

  attr_accessor :name_frequency_provider

  def initialize(name_frequencies)
    @female_frequencies = name_frequencies["female"]
    @male_frequencies = name_frequencies["male"]
  end

  def gender_for(name)
    name = name.upcase

    female_score = listed_frequency(@female_frequencies, name)
    male_score   = listed_frequency(@male_frequencies, name)

    if female_score.zero?
      closest_name, match_factor = best_match_and_factor_in(@female_frequencies.keys, name)
      match_factor = 0 if match_factor < MINIMUM_JARO_WINKLER_MATCH_DISTANCE
      female_score = listed_frequency(@female_frequencies, closest_name) * match_factor
    end

    if male_score.zero?
      closest_name, match_factor = best_match_and_factor_in(@male_frequencies.keys, name)
      match_factor = 0 if match_factor < MINIMUM_JARO_WINKLER_MATCH_DISTANCE
      male_score = listed_frequency(@male_frequencies, closest_name) * match_factor
    end

    if female_score == male_score
      'Unknown'
    elsif female_score > male_score
      'F'
    else
      'M'
    end
  end

  private

  def listed_frequency(hash, name)
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

