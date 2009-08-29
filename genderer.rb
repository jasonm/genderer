require 'rubygems'
require 'amatch'

class Genderer
  def self.gender_for(name)
    self.instance.gender_for(name)
  end

  def initialize
    build_name_frequency_hashes
  end

  def gender_for(name)
    female_frequency = listed_frequency(@female_frequencies, name)
    male_frequency   = listed_frequency(@male_frequencies, name)

    if female_frequency == male_frequency
      'Unknown'
    elsif female_frequency > male_frequency
      'F'
    else
      'M'
    end
  end

  private

  def listed_frequency(hash, name)
    name = name.upcase

    if ! hash.has_key?(name)
      closest_name = closest_name_in(hash.keys, name)
      hash[name] = hash[closest_name]
    end

    hash[name] || 0
  end

  def closest_name_in(list, name)
    name_matcher = Amatch::JaroWinkler.new(name.upcase)
    list.sort_by { |other| name_matcher.match(other) }.last
  end

  def self.instance
    @@instance ||= Genderer.new
  end

  def build_name_frequency_hashes
    @female_frequencies = {}
    @male_frequencies = {}

    @female_frequencies = name_frequency_hash_for("female")
    @male_frequencies   = name_frequency_hash_for("male")
  end

  def name_frequency_hash_for(gender)
    hash = {}

    lines = open("dist.#{gender}.first").readlines.each do |line|
      name = line.split[0].upcase
      frequency = line.split[1].to_f
      hash[name] = frequency
    end

    hash
  end
end

