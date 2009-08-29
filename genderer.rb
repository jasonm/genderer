require 'rubygems'
require 'amatch'
require 'weighted_match'
require 'census_file_name_frequencies'

class Genderer
  def initialize(name_frequencies = CensusFileNameFrequencies.gender_hashes)
    @name_frequencies = name_frequencies
  end

  def gender_for(name)
    name = name.upcase

    scores_by_category = {}
    @name_frequencies.keys.each do |category|
      scores_by_category[category] = score_category_by(@name_frequencies[category], name)
    end

    scores        = scores_by_category.values
    winning_score = scores.max
    tie           = scores.all? { |score| score == winning_score }
    winner        = scores_by_category.invert[winning_score]

    if tie
      "unknown"
    else
      winner
    end
  end

  private

  def score_category_by(hash, name)
    score = frequency_by(hash, name)
    if score.zero?
      match = WeightedMatch.new(hash.keys, name)
      score = frequency_by(hash, match.best_match) * match.weight
    end
    score
  end

  def frequency_by(hash, name)
    hash[name] || 0
  end
end
