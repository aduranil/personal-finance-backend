require 'date'

class User < ApplicationRecord
  has_secure_password

  has_many :accounts
  has_many :transactions, through: :accounts
  has_many :filereaders, through: :accounts

  validates :password, length: { in: 6..20 }
  validates :username, uniqueness: true
  validates :username, presence: true
  validates :password, presence: true

  def data
    total = 0
    ced_hash = Hash.new(0)
    med_hash = Hash.new(0)
    mf_hash = Hash.new(0)
    cf_hash = Hash.new(0)
    hash = Hash.new(0)
    self.accounts.each do |account|
      total += account.balance
    end
    self.transactions.each do |transaction|
      d = transaction.period_name unless transaction.period_name == nil
      d = d.strftime('%b-%Y') unless transaction.period_name == nil

      if hash[d]
        hash[d] += transaction.amount.round * -1 unless transaction.amount == nil
      else
        hash[d]
      end

      if ced_hash[transaction.category_name]
        ced_hash[transaction.category_name] += transaction.amount.round unless transaction.amount == nil
        cf_hash[transaction.category_name] +=1
      else
        cf_hash[transaction.category_name] = 0
        ced_hash[transaction.category_name] = 0
      end

      if med_hash[transaction.merchant_name]
        med_hash[transaction.merchant_name] += transaction.amount.round unless transaction.amount == nil
        mf_hash[transaction.merchant_name] +=1
      else
        mf_hash[transaction.merchant_name] = 0
        med_hash[transaction.merchant_name] = 0
      end

    end
    return {account_balance: total, category_expense_data: Hash[ced_hash.sort_by{|k, v| v}.reverse],
            merchant_expense_data: Hash[med_hash.sort_by{|k, v| v}.reverse],
            merchant_frequency: Hash[mf_hash.sort_by{|k, v| v}.reverse],
          category_frequency: Hash[cf_hash.sort_by{|k, v| v}.reverse], spend_by_month: Hash[hash.sort_by{|k, v| Date.parse(k)}]}
  end


  def average_spend
    total = 0
    if self.transactions.length > 0
      self.transactions.each do |t|
        total += t.amount.round unless t.amount == nil
      end
    end
    total / self.transactions.size unless self.transactions.size == 0
  end


end
