class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password_digest, :average_spend, :data

  has_many :accounts
  has_many :transactions, through: :accounts
end
