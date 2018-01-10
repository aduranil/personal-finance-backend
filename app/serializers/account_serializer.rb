class AccountSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :type
end
