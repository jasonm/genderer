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
