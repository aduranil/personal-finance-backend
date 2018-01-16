class AccountSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :balance
  has_many :transactions



  def transaction_data
    object.transactions.map do |transaction|
      {
        id: transaction.id,
        description: transaction.description,
        amount: transaction.amount,
        category: transaction.category.name,
        merchant: transaction.merchant.name,
        period: transaction.period.date,
        debit_or_credit: transaction.debit_or_credit
      }
    end
  end
end
