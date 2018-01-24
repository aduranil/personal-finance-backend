class AddDataToAuthenticators < ActiveRecord::Migration[5.1]
  def change
    add_column :authenticators, :institution, :string
    add_column :authenticators, :account, :string
    add_column :authenticators, :account_id, :string
    add_column :authenticators, :accounts, :string
    add_column :authenticators, :link_session_id, :string
    add_column :authenticators, :public_token, :string
  end
end
