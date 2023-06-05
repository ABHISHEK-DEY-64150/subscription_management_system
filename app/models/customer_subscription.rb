class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  validates :package_id, uniqueness: { scope: :customer_id, message: "*****already subscribed" }
end
