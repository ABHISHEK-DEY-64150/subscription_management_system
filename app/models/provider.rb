class Provider < ApplicationRecord
  has_many:customers
  has_secure_password
end
