class AccountSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :balance
  has_many :transactions
  has_many :categories, through: :transactions
  has_many :merchants, through: :transactions
  has_many :dates, through: :transactions
  
end