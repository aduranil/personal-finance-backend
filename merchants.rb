require 'csv'
require 'pry'
require 'classifier-reborn'
require 'fast-stemmer'

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

merchant = ClassifierReborn::Bayes.new(merchants)
array.each do |x|
  merchant.train(x.first, x.last)
end

classifier_data = Marshal.dump(merchant)
File.open("merchants.dat", "w") {|f| f.write(classifier_data) }
