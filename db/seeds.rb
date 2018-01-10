require 'csv'
require 'pry'

transactions = File.read("./db/transactions.csv")
transactions = CSV.parse(transactions, :headers => true, :encoding => 'ISO-8859-1')

transactions.each do |column|
    Transaction.create(description: column[2], amount: column[3], category: Category.find_or_create_by(name: column[5]), merchant: Merchant.find_or_create_by(name: column[1]), account: Account.find_or_create_by(name: column[6], user_id: 1), period: Period.find_or_create_by(date: column[0]), debit_or_credit: column[4])
end

# transactions[0..3].each do |column|
# end
