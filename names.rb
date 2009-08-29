#!/usr/bin/env ruby
require 'genderer'

if ARGV.any?
  puts Genderer.gender_for(ARGV.first)
else
  puts "Usage: ./names.rb name"
end
