class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :merchants, through: :transactions
  has_many :categories, through: :transactions
end
