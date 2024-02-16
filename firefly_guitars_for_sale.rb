require 'nokogiri'
require 'open-uri'

def guitars(site:, product_id:, page:)
  page = Nokogiri::HTML(URI.open("#{site}?page=#{page}"))

  page.search("a")
    .map { |a| a[:href] }
    .compact
    .delete_if { |a| a.match?("#{site}?page=") }
    .select { |a| a.include?(product_id) }
    .reject { |a| a.include?("?page=") }
    .uniq
    .map{ |a| "https://guitarsgarden.com#{a}" }
end

def search_products(site:, product_id:)
  products = []

  1.step do |page|
    products_in_page = guitars(site:, product_id:, page:).reject { |a| a == site }
    break if products_in_page.empty? || page == 5

    products += products_in_page
  end

  products.compact.sort
end

lp_guitars = search_products(
  site: "https://guitarsgarden.com/collections/fflp-electric-guitars",
  product_id: "fflp",
)
s_guitars = search_products(
  site: "https://guitarsgarden.com/collections/sg",
  product_id: "ffst",
)

guitars = lp_guitars + s_guitars
puts guitars

File.open("available_guitars.txt", "w") { |f| f.write guitars.join("\n") }
