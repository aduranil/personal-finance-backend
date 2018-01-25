class ChangeTokenInAuthenticators < ActiveRecord::Migration[5.1]
  def change
    change_column :authenticators, :token, :jsonb, using: 'token::jsonb'
  end
end
