class Category < ApplicationRecord
  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end