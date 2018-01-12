class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :merchant
  belongs_to :category
  belongs_to :period

  def self.total
    total = 0
    Transaction.all.each do |transaction|
      if transaction.debit_or_credit == "debit"
        transaction.amount = transaction.amount * -1
      end
      total += transaction.amount
    end
    return total
  end
end
