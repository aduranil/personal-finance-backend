class RemoveTokenFromAuthenticators < ActiveRecord::Migration[5.1]
  def change
    remove_column :authenticators, :token, :string
  end
end
