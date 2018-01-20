class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :description, :amount,  :debit_or_credit, :category_name, :merchant_name, :account_name, :period_name, :account_id
end
