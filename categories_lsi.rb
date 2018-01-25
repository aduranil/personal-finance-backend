require 'csv'
require 'pry'
require 'classifier-reborn'
require 'fast-stemmer'
require 'gsl'

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

array = array.uniq
array = array[0..200]
category = ClassifierReborn::LSI.new

array.each do |x|
  category.add_item(x.first, x.last)
end

classifier_data = Marshal.dump(category)
File.open("categories_lsi.dat", "w") {|f| f.write(classifier_data) }
