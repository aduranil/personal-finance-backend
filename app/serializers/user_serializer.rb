class UserSerializer < ActiveModel::Serializer
  attributes :merchants, :categories, :spend_by_month, :merchant_frequency, :average_spend,:category_expense_data, :id, :username, :password_digest, :account_balance, :merchant_expense_data, :category_frequency

  has_many :accounts
  has_many :transactions, through: :accounts

end
