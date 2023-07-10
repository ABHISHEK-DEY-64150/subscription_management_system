class Bill < ApplicationRecord
    belongs_to :customer

    validates :customer_id, uniqueness: { scope: [:package_id, :provider_id, :date, :due_date] }
end
