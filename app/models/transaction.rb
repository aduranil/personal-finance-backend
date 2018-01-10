class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :merchant
  belongs_to :category
  belongs_to :period
end
