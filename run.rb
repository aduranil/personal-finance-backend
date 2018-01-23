require 'classifier'
require 'csv'
require 'pry'
merchant = Classifier::LSI.new
data = CSV.parse(File.read('./merchantnames.csv'))
data.each do |x|
  merchant.add_item x.last, x.first
end

classifier_data = Marshal.dump(merchant)
File.open("classify.dat", "w") {|f| f.write(classifier_data) }
