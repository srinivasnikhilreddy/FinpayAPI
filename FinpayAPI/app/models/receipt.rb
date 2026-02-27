class Receipt < ApplicationRecord
  belongs_to :expense

  validates :file_url,
            presence: true

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }
end