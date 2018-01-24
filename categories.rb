
require 'csv'
require 'pry'
require 'classifier-reborn'
require 'gsl'
category = ClassifierReborn::LSI.new
data = CSV.parse(File.read('./transactions.csv'))
data.each do |x|
  category.add_item x.first, x.last
end

classifier_data = Marshal.dump(category)
File.open("categories.dat", "w") {|f| f.write(classifier_data) }
