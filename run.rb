require 'csv'
require 'pry'
require 'classifier-reborn'
require 'gsl'
categorystuff = ClassifierReborn::LSI.new
data = CSV.parse(File.read('./tra.csv'))
data.each do |x|
  categorystuff.add_item x.first, x.last
end

classifier_data = Marshal.dump(categorystuff)
File.open("classifier.dat", "w") {|f| f.write(classifier_data) }
