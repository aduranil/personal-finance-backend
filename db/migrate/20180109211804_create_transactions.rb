class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.float :amount
      t.string :debit_or_credit
      t.string :category_name
      t.string :merchant_name
      t.string :account_name
      t.integer :account_id
      t.date :period_name

      t.timestamps
    end
  end
end
