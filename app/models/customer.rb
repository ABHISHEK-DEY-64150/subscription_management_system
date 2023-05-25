class Customer < ApplicationRecord
  belongs_to :provider
  has_secure_password
end
