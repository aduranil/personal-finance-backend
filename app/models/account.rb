require 'pry'
require 'byebug'
class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :merchants, through: :transactions
  has_many :categories, through: :transactions

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

  def self.total
    total = 0
    Account.all.each do |account|
      total += account.balance
    end
    return total
  end

  def self.debits
  end 

end
