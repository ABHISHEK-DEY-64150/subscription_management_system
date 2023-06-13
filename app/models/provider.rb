class Provider < ApplicationRecord
  has_many:customers
  has_many:packages
  has_secure_password

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true                   

end
