require 'pry'
require 'byebug'
class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :filereaders

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
