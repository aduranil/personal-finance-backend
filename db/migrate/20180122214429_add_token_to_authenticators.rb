class AddTokenToAuthenticators < ActiveRecord::Migration[5.1]
  def change
    add_column :authenticators, :token, :jsonb
  end
end
