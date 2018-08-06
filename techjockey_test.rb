require 'rubygems'
require 'nokogiri'
require 'nokogiri-styles'
require 'open-uri'
require 'openssl'
#require 'builder'
require 'csv'

url = "https://www.techjockey.com/industry/ites"

doc = Nokogiri::HTML(open(url))

products = []
doc.css(".f-18 a").each do |link|
  products << link.values
end

puts products.count

manju = products[1].first
doc1 = Nokogiri::HTML(open(manju))
# puts doc1.at_css(".new_product_descrip_mid h3").text
# puts price = doc1.at_css(".new_price_label").content
# puts price.squish
# about = doc1.at_css("#basic_info p")
# if about.present?
#   puts item["about"] = doc1.at_css("#basic_info p").text
# end
# puts doc1.at_css("#descrip_video_section")['src']
# puts doc1.at_css(".about_OEM_info div").content
# puts doc1.at_css(".m-b-10:nth-child(1) .col-xs-12 p").content
# puts doc1.at_css(".m-b-10+ .m-b-10 .col-xs-12 p").content
# puts doc1.at_css(".m-b-10.new_mobile_alignment:nth-child(1) p").content
# manjugowda = doc1.at_css(".new_mobile_alignment_outer .row .new_mobile_alignment").content
# manju = manjugowda.split("\r\n           ").reject(&:blank?).map {|x| x.squish}
# array = []
# i = 0
# while i < manju.count
#   array << {manju[i] => manju[i+ 1]}
#   i += 2
# end
# puts array
# salman = doc1.at_css(".col-sm-8.new_mobile_alignment").content
# p salu = salman.split("\r\n ").reject(&:blank?).map {|x| x.squish}
# taju = doc1.at_css(".col-sm-7").content
# p taj = taju.split("\r\n ").reject(&:blank?).map {|x| x.squish}

# array = []
# i = 0
# while i < salu.count
#   array << {salu[i] => taj[i]}
#   i += 1
# end
# array
# p array.unshift({"size" => "Organization_type"})
# puts doc1.at_css("#default_img")['src']
# compares = doc1.at_css("#compare .row").content
# comp = compares.split("\r\n ").reject(&:blank?).map {|x| x.squish}
# array = []
# i = 0
# while i < comp.count - 1
#   array << comp[i + 1]
#   i += 2
# end
# p array
# puts node = doc1.at_css(".star-ratings-sprite")
# p node['style']

####################################################################################
items = []
products.each do |prod|
  item = {}
  link = prod.first

  doc1 = Nokogiri::HTML(open(link))
  item["Name"] = doc1.at_css(".new_product_descrip_mid h3").text
  price = doc1.at_css(".new_price_label").content
  item["Price"] = price.squish
  about = doc1.at_css("#basic_info p")
  if about.present?
    item["About Product"] = doc1.at_css("#basic_info p").text
  else
    item["About Product"] = ""
  end
  if doc1.at_css("#default_img").present?
    item["Image Link"] = doc1.at_css("#default_img")['src']
  else
    item["Image Link"] = ""
  end
  video = doc1.at_css("#descrip_video_section")
  if video.present?
    item["Video Link"] = doc1.at_css("#descrip_video_section")['src']
  else
    item["Video Link"] = ""
  end
  item["About Technology"] = doc1.at_css(".about_OEM_info div").content
  deployment = doc1.at_css(".m-b-10:nth-child(1) .col-xs-12 p")
  if deployment.present?
    item["Deployment"] = doc1.at_css(".m-b-10:nth-child(1) .col-xs-12 p").content
  else
    item["Deployment"] = ""
  end
  operating_system = doc1.at_css(".m-b-10+ .m-b-10 .col-xs-12 p")
  if operating_system.present?
    item["Operating System"] = doc1.at_css(".m-b-10+ .m-b-10 .col-xs-12 p").content
  else
    item["Operating System"] = ""
  end
  if doc1.at_css(".m-b-10.new_mobile_alignment:nth-child(1) p").present?
    item["Hardware Config"] = doc1.at_css(".m-b-10.new_mobile_alignment:nth-child(1) p").content
  else
    item["Hardware Config"] = ""
  end
  if doc1.at_css(".col-sm-8.new_mobile_alignment").present?
    sizes = doc1.at_css(".col-sm-8.new_mobile_alignment").content
    size = sizes.split("\r\n ").reject(&:blank?).map {|x| x.squish}
    organization = doc1.at_css(".col-sm-7").content
    organiz = organization.split("\r\n ").reject(&:blank?).map {|x| x.squish}

    array = []
    i = 0
    while i < size.count
      array << {size[i] => organiz[i]}
      i += 1
    end
    array
    array.unshift({"size" => "Organization_type"})
    item["Best suitable for"] = array
  else
    item["Best suitable for"] = "" 
  end
  if doc1.at_css(".new_mobile_alignment_outer .row .new_mobile_alignment").present?
    manjugowda = doc1.at_css(".new_mobile_alignment_outer .row .new_mobile_alignment").content
    manju = manjugowda.split("\r\n ").reject(&:blank?).map {|x| x.squish}
    array = []
    i = 0
    while i < manju.count
      array << {manju[i] => manju[i+ 1]}
      i += 2
    end
    item["Features"] = array
  else
    item["Features"] = ""
  end
  if doc1.at_css("#compare .row").present?
    compares = doc1.at_css("#compare .row").content
    comp = compares.split("\r\n ").reject(&:blank?).map {|x| x.squish}
    array = []
    i = 0
    while i < comp.count - 1
      array << comp[i + 1]
      i += 2
    end
    item["Compare"] = array
  else
    item["Compare"] = ""
  end
  items << item
end
@data = items

#############################################################################################
# headers = hashArray.inject([]){|a,x| a |= x.keys ; a}                               

#   html = Builder::XmlMarkup.new(:indent => 2)
#   data = html.table {
#     html.tr { headers.each{|h| html.th(h)} }
#     hashArray.each do |row|
#       html.tr { row.values.each { |value| html.td(value) }}
#     end
#   }

# # html
# aFile = File.new("tech.html", "w")
#    if aFile
#     aFile.syswrite(@data)
#    else
#     puts "ERROR!"
#    end
# aFile.close

# CSV   
require 'csv'
CSV.open("ites.csv", "wb") do |csv|
  csv << @data.first.keys # adds the attributes name on the first line
  @data.each do |hash|
    csv << hash.values
  end
end