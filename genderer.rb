#!/usr/bin/env ruby

class Genderer
  def self.gender_for(name)
    self.instance.gender_for(name)
  end

  def initialize
    build_name_frequency_hashes
  end

  def gender_for(name)
    female_frequency = @female_frequencies[name.upcase] || 0
    male_frequency   = @male_frequencies[name.upcase]   || 0

    if female_frequency == male_frequency
      'Unknown'
    elsif female_frequency > male_frequency
      'F'
    else
      'M'
    end
  end

  private

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

if ARGV.any?
  puts Genderer.gender_for(ARGV.first)
else
  puts "Usage: ./names.rb name"
end
