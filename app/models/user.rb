class User < ApplicationRecord
  has_secure_password
  has_many :accounts
  has_many :transactions, through: :accounts
  has_many :categories, through: :transactions
  has_many :merchants, through: :transactions

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
    categories = self.categories.uniq
    categories.each do |category|
      self.transactions.each do |transaction|
        if transaction.category_name == category.name
          hash[category.name] += transaction.amount.round
        end
      end
    end
    hash.select {|category, amount| amount < 0}.sort_by {|merchant,amount| amount}
  end

  def merchant_expense_data
    hash = Hash.new(0)
    merchants= self.merchants.uniq
    merchants.each do |merchant|
      self.transactions.each do |transaction|
        if transaction.merchant_name == merchant.name
          hash[merchant.name] += transaction.amount.round
        end
      end
    end
    hash.select {|merchant, amount| amount < 0}.sort_by {|merchant, amount| amount}
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
