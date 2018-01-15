require 'pry'
require 'byebug'
class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :merchants, through: :transactions
  has_many :categories, through: :transactions
  has_many :periods, through: :transactions

  def balance
    total = 0
    self.transactions.each do |transaction|
      if transaction.debit_or_credit == "debit"
        transaction.amount = transaction.amount * -1
      end
      total += transaction.amount
    end
    self.balance = total
  end

end
