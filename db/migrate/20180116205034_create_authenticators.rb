class CreateAuthenticators < ActiveRecord::Migration[5.1]
  def change
    create_table :authenticators do |t|

      t.timestamps
    end
  end
end
