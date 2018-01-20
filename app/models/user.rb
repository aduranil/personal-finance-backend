require 'date'

class User < ApplicationRecord
  has_secure_password

  has_many :accounts
  has_many :transactions, through: :accounts
  validates :password, length: { in: 6..20 }, message: "password must be between 6 and 20 characters"
  validates :username, uniqueness: true, message: "username already exists"

  def account_balance
    total = 0
    self.transactions.each do |transaction|
      if transaction.debit_or_credit == "debit"
        transaction.amount = transaction.amount * -1
      end
      total += transaction.amount
    end
    return total
  end

  def category_expense_data
    hash = Hash.new(0)
      self.transactions.each do |transaction|
        if hash[transaction.category_name]
          hash[transaction.category_name] += transaction.amount.round
        else
          hash[transaction.category_name] = 0
        end
      end
    Hash[hash.sort_by{|k, v| v}.reverse]
  end

  def merchant_expense_data
    hash = Hash.new(0)
      self.transactions.each do |transaction|
        if hash[transaction.merchant_name]
          hash[transaction.merchant_name] += transaction.amount.round
        else
          hash[transaction.merchant_name] = 0
        end
      end
    Hash[hash.sort_by{|k, v| v}.reverse]
  end

  def merchant_frequency
    hash = Hash.new(0)
    self.transactions.each do |transaction|
      if hash[transaction.merchant_name]
        hash[transaction.merchant_name] +=1
      else
        hash[transaction.merchant_name] = 0
      end
    end
    Hash[hash.sort_by{|k, v| v}.reverse]
  end

  def category_frequency
    hash = Hash.new(0)
    self.transactions.each do |transaction|
      if hash[transaction.category_name]
        hash[transaction.category_name] +=1
      else
        hash[transaction.category_name] = 0
      end
    end
    Hash[hash.sort_by{|k, v| v}.reverse]
  end

  def spend_by_month
    hash = Hash.new(0)
    self.transactions.each do |transaction|
      d = transaction.period_name
      d = d.strftime('%b-%Y')
      if hash[d]
        hash[d] += transaction.amount.round
      else
        hash[d]
      end
    end
    hash
  end

  def average_spend
    if self.transactions.length > 0
      amount = self.transactions.map {|transaction| transaction[:amount]}.inject{ |sum, el| sum + el }.to_f / self.transactions.size
      amount.round
    else
      0
    end
  end


end
