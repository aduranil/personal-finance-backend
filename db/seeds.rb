require 'csv'
require 'pry'

transactions = File.read("./db/transactions.csv")
transactions = CSV.parse(transactions)
transactions.each do |column|
  Category.find_or_create_by(name: column[5])
  Merchant.find_or_create_by(name: column[1])
  Period.find_or_create_by(date: column[0])
end


transactions.each do |column|
    Transaction.create(description: column[2], amount: column[3], category: Category.find_by(name: column[5]), merchant: Merchant.find_by(name: column[1]), account: Account.find_by(name: column[6]), period: Period.find_by(date: column[0]), debit_or_credit: column[4])
end

# transactions[0..3].each do |column|
# end
