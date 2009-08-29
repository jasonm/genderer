#!/usr/bin/env ruby
require 'genderer'

if ARGV.any?
  puts Genderer.gender_for(ARGV.first)
else
  puts "Usage: ./gender_for.rb name"
end
