class UserSerializer < ActiveModel::Serializer
  attributes :average_spend, :id, :username, :password_digest, :account_balance, :category_expense_data, :merchant_expense_data, :highest_category
  has_many :accounts
  has_many :transactions, through: :accounts

end
