class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  validates_uniqueness_of :package_id, scope: [:customer_id]
end
