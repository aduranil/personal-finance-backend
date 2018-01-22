class CreateFilereaders < ActiveRecord::Migration[5.1]
  def change
    create_table :filereaders do |t|
      t.attachment :file_upload
      t.integer :account_id

      t.timestamps
    end
  end
end
