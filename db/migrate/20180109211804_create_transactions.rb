class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.float :amount
      t.integer :category_id
      t.integer :merchant_id
      t.integer :account_id
      t.integer :period_id
      t.string :debit_or_credit

      t.timestamps
    end
  end
end
