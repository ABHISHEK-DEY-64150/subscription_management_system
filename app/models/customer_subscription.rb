class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  validates :package_id,numericality: {greater_than: 0}, uniqueness: { scope: :customer_id, message: "*****already subscribed" }
  
end
