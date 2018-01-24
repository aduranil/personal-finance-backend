
require 'csv'
require 'pry'
require 'classifier-reborn'
require 'gsl'
 merchant = ClassifierReborn::LSI.new
data = CSV.parse(File.read('./merchantnames.csv'))
data.each do |x|
   merchant.add_item x.last, x.first
end

classifier_data = Marshal.dump( merchant)
File.open("merchants.dat", "w") {|f| f.write(classifier_data) }
