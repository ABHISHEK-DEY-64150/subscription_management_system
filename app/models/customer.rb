class Customer < ApplicationRecord
  belongs_to :provider
  has_many :CustomerSubscription
  has_secure_password

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
                    
end
