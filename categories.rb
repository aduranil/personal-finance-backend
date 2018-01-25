require 'csv'
require 'pry'
require 'classifier-reborn'
require 'fast-stemmer'

data = File.read('./categories.csv').split("\r\n")
data = data.uniq
array = []
data.each do |item|
  array << item.split(',')
end

categories = []

array.each do |item|
  categories << item[1]
end
categories = categories.uniq

category = ClassifierReborn::Bayes.new(categories)

array.each do |x|
  category.train(x.last, x.first)
end

classifier_data = Marshal.dump(category)
File.open("categories.dat", "w") {|f| f.write(classifier_data) }
