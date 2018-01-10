class User < ApplicationRecord
  has_secure_password
  has_many :accounts
  has_many :transactions, through: :accounts
end
