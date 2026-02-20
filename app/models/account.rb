class Account < ApplicationRecord
  has_many :transactions

  validates :balance, numericality: true

end
