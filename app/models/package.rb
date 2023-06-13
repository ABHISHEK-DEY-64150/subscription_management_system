class Package < ApplicationRecord
  belongs_to :provider
  validates :description,presence: true
  validates :price, presence: true ,numericality: {greater_than: 0}
end
