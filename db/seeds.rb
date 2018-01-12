require 'csv'
require 'pry'

transactions = File.read("./db/transactiondata.csv")
transactions = CSV.parse(transactions, :headers => true, :encoding => 'ISO-8859-1')

transactions.each do |row|
    Transaction.create(
      description: row["Original Description"],
      amount: row["Amount"],
      period_name: row[6],
      category: Category.find_or_create_by(name: row["Category"]),
      merchant: Merchant.find_or_create_by(name: row["Description"]),
      account: Account.find_or_create_by(name: row["Account Name"], user_id: 1),
      period: Period.find_or_create_by(date: row["When"]),
      debit_or_credit: row["Transaction Type"],
      category_name: row["Category"],
      merchant_name: row["Description"],
      account_name: row["Account Name"])
end

Transaction.create(account_id:1, category: Category.find_or_create_by(name: "balance adjustment"), debit_or_credit: "debit", amount: 200
0, period_id:1, merchant: Merchant.find_or_create_by(name: "balance adjustment"))
Transaction.create(account_id:3, category: Category.find_or_create_by(name: "balance adjustment"), debit_or_credit: "credit", amount: 80
00, period_id:25, merchant: Merchant.find_or_create_by(name: "balance adjustment"))
Transaction.create(account_id:7, category: Category.find_or_create_by(name: "balance adjustment"), debit_or_credit: "debit", amount: 750
00, period_id:25, merchant: Merchant.find_or_create_by(name: "balance adjustment"))
