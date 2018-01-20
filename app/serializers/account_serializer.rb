class AccountSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :balance
  has_many :transactions

end
