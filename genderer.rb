require 'rubygems'
require 'amatch'
require 'weighted_match'
require 'census_file_name_frequencies'

class Genderer
  def initialize(name_frequencies = CensusFileNameFrequencies.gender_hashes)
    @female_frequencies = name_frequencies["female"]
    @male_frequencies   = name_frequencies["male"]
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
      match = WeightedMatch.new(hash.keys, name)
      score = frequency_by(hash, match.best_match) * match.weight
    end
    score
  end

  def frequency_by(hash, name)
    name = name.upcase
    hash[name] || 0
  end
end
