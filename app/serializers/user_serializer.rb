class UserSerializer < ActiveModel::Serializer
  attributes :merchant_expense_data,:merchant_frequency, :average_spend,:category_expense_data, :id, :username, :password_digest, :account_balance,:highest_category

  has_many :accounts
  has_many :transactions, through: :accounts

end
