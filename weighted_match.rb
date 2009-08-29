class WeightedMatch
  MINIMUM_JARO_WINKLER_MATCH_DISTANCE = 0.75

  attr_reader :best_match, :weight

  def initialize(list, item)
    matcher = Amatch::JaroWinkler.new(item)
    matcher.ignore_case = true
    weights = matcher.match(list)

    @weight = weights.max
    @weight = 0 if @weight < MINIMUM_JARO_WINKLER_MATCH_DISTANCE

    @best_match = list[weights.index(@weight)]
  end
end

