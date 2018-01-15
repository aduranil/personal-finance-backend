class User < ApplicationRecord
  has_secure_password
  has_many :accounts
  has_many :transactions, through: :accounts
  has_many :categories, through: :transactions
  has_many :merchants, through: :transactions
  has_many :periods, through: :transactions

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
    hash.sort_by {|name,amount| amount}
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
    hash.sort_by {|name, amount| amount}
  end

  def merchant_frequency
    hash = Hash.new(0)
    self.merchants.each do |merchant|
      if hash[merchant.name]
        hash[merchant.name] +=1
      else
        hash[merchant.name] = 0
      end
    end
    hash
  end

  def spend_by_month
    hash = Hash.new(0)
  end

  def average_spend
    amount = self.transactions.map {|transaction| transaction[:amount]}.inject{ |sum, el| sum + el }.to_f / self.transactions.size
    amount.round
  end

  def highest_category
    category_expense_data[0..2]
  end

  def highest_merchant
    merchant_expense_data[0..2]
  end


end
