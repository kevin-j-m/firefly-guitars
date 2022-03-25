require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(URI.open("https://guitarsgarden.com/collections/fflp-electric-guitars"))

guitars = doc.search("a").
  map {|a| a[:href]}.
  compact.
  select { |a| a.include?("/collections/fflp-electric-guitars/products") }.
  uniq.
  map{ |a| "https://guitarsgarden.com#{a}" }.
  sort

puts guitars

File.open("available_guitars.txt", "w") { |f| f.write guitars.join("\n") }
