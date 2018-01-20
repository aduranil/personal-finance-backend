class AddMetadataToAuthenticators < ActiveRecord::Migration[5.1]
  def change
    add_column :authenticators, :metadata, :string
  end
end
