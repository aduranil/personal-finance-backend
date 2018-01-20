class AddUserIdToAuthenticators < ActiveRecord::Migration[5.1]
  def change
    add_column :authenticators, :user_id, :integer 
  end
end
