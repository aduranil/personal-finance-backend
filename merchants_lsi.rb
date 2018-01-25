require 'csv'
require 'pry'
require 'classifier-reborn'
require 'fast-stemmer'
require 'gsl'

data = File.read('./merchantnames.csv').split("\r\n")
data = data.uniq
array = []
data.each do |item|
  array << item.split(',')
end

merchants = []

array.each do |item|
  merchants << item[0]
end
merchants = merchants.uniq

merchant = ClassifierReborn::LSI.new

array.each do |x|
  merchant.add_item(x.last, x.first)
end

classifier_data = Marshal.dump(merchant)
File.open("merchants_lsi.dat", "w") {|f| f.write(classifier_data) }
