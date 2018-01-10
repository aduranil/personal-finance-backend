class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :description, :amount, :category_id, :merchant_id, :account_id, :period_id, :debit_or_credit
end
