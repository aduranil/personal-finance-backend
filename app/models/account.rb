require 'pry'
require 'byebug'
class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :filereaders

  def balance
    total = 0
    self.transactions.each do |transaction|
      if  transaction.amount != nil && transaction.debit_or_credit == "debit" && transaction.amount > 0 
        transaction.amount = transaction.amount * -1
      end
      total += transaction.amount unless transaction.amount == nil
    end
    self.balance = total
  end

end
