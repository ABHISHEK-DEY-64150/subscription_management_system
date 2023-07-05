class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :provider

  validates :title, presence: true
  validates :description, presence: true

  # Other methods or custom validations can be added here
end