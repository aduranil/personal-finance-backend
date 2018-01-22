class AddFileToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_attachment :transactions, :file_upload
  end
end
