class Provider < ApplicationRecord
  has_many:customers
  has_many:packages
  has_secure_password
end
